import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EnhancedWeb3Service {
  late final Web3Client _client;
  final FlutterSecureStorage _secureStorage;
  final String _networkUrl;
  final int _chainId;
  
  // Cache for contracts and ABIs
  final Map<String, DeployedContract> _contractCache = {};
  final Map<String, dynamic> _abiCache = {};
  
  // Event streams
  final Map<String, Stream<FilterEvent>> _eventStreams = {};
  
  EnhancedWeb3Service({
    required String networkUrl,
    required int chainId,
  }) : _networkUrl = networkUrl,
       _chainId = chainId,
       _secureStorage = const FlutterSecureStorage();

  // Initialization
  Future<void> initialize() async {
    final httpClient = Client();
    _client = Web3Client(_networkUrl, httpClient);
  }

  // Contract Management
  Future<DeployedContract> loadContract({
    required String address,
    required String abi,
    required String name,
  }) async {
    if (_contractCache.containsKey(address)) {
      return _contractCache[address]!;
    }

    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(abi, name),
        EthereumAddress.fromHex(address),
      );
      
      _contractCache[address] = contract;
      _abiCache[address] = abi;
      
      return contract;
    } catch (e) {
      throw Web3Exception('Failed to load contract: ${e.toString()}');
    }
  }

  // Transaction Execution
  Future<String> executeTransaction({
    required String contractAddress,
    required String functionName,
    required List<dynamic> params,
    BigInt? value,
    String? privateKey,
  }) async {
    try {
      final contract = await _getContract(contractAddress);
      final function = contract.function(functionName);
      
      // Get credentials
      final credentials = await _getCredentials(privateKey);
      
      // Estimate gas and get current gas price
      final gasPrice = await _client.getGasPrice();
      final maxGas = await _client.estimateGas(
        sender: credentials.address,
        to: contract.address,
        data: function.encodeCall(params),
        value: value != null ? EtherAmount.inWei(value) : null,
      );

      // Execute transaction
      final transaction = await _client.sendTransaction(
        credentials,
        Transaction(
          to: contract.address,
          data: function.encodeCall(params),
          maxGas: maxGas.toInt(),
          gasPrice: gasPrice,
          value: value != null ? EtherAmount.inWei(value) : null,
        ),
        chainId: _chainId,
      );

      return transaction;
    } catch (e) {
      throw Web3Exception('Transaction execution failed: ${e.toString()}');
    }
  }

  // Read Contract Data (No Gas Required)
  Future<List<dynamic>> readContract({
    required String contractAddress,
    required String functionName,
    required List<dynamic> params,
  }) async {
    try {
      final contract = await _getContract(contractAddress);
      final function = contract.function(functionName);
      
      return await _client.call(
        contract: contract,
        function: function,
        params: params,
      );
    } catch (e) {
      throw Web3Exception('Contract read failed: ${e.toString()}');
    }
  }

  // Gas Estimation
  Future<BigInt> estimateGasForTransaction({
    required String contractAddress,
    required String functionName,
    required List<dynamic> params,
    BigInt? value,
  }) async {
    try {
      final contract = await _getContract(contractAddress);
      final function = contract.function(functionName);
      final credentials = await _getCredentials(null);
      
      return await _client.estimateGas(
        sender: credentials.address,
        to: contract.address,
        data: function.encodeCall(params),
        value: value != null ? EtherAmount.inWei(value) : null,
      );
    } catch (e) {
      throw Web3Exception('Gas estimation failed: ${e.toString()}');
    }
  }

  // Event Handling
  Stream<FilterEvent> subscribeToEvent({
    required String contractAddress,
    required String eventName,
  }) {
    final streamKey = '$contractAddress-$eventName';
    if (_eventStreams.containsKey(streamKey)) {
      return _eventStreams[streamKey]!;
    }

    try {
      final contract = _contractCache[contractAddress];
      if (contract == null) {
        throw Web3Exception('Contract not loaded');
      }

      final event = contract.event(eventName);
      final filter = FilterOptions.events(
        contract: contract,
        event: event,
      );
      
      final stream = _client.events(filter).asBroadcastStream();
      _eventStreams[streamKey] = stream;
      
      return stream;
    } catch (e) {
      throw Web3Exception('Event subscription failed: ${e.toString()}');
    }
  }

  // Oracle Integration
  Future<String> submitToOracle({
    required String oracleAddress,
    required String functionName,
    required String data,
    required BigInt payment,
  }) async {
    try {
      return await executeTransaction(
        contractAddress: oracleAddress,
        functionName: functionName,
        params: [data],
        value: payment,
      );
    } catch (e) {
      throw Web3Exception('Oracle submission failed: ${e.toString()}');
    }
  }

  // Off-chain Processing
  Future<Map<String, dynamic>> processOffChain({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await Client().post(
        Uri.parse(endpoint),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );
      
      if (response.statusCode != 200) {
        throw Web3Exception('Off-chain processing failed with status: ${response.statusCode}');
      }
      
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Web3Exception('Off-chain processing failed: ${e.toString()}');
    }
  }

  // Utility Methods
  Future<EtherAmount> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      return await _client.getBalance(ethAddress);
    } catch (e) {
      throw Web3Exception('Failed to get balance: ${e.toString()}');
    }
  }

  Future<int> getBlockNumber() async {
    try {
      return await _client.getBlockNumber();
    } catch (e) {
      throw Web3Exception('Failed to get block number: ${e.toString()}');
    }
  }

  // Private Helper Methods
  Future<DeployedContract> _getContract(String address) async {
    final contract = _contractCache[address];
    if (contract == null) {
      throw Web3Exception('Contract not loaded');
    }
    return contract;
  }

  Future<Credentials> _getCredentials(String? privateKey) async {
    if (privateKey != null) {
      return EthPrivateKey.fromHex(privateKey);
    }
    
    // Use stored credentials if available
    final storedKey = await _secureStorage.read(key: 'ethereum_private_key');
    if (storedKey != null) {
      return EthPrivateKey.fromHex(storedKey);
    }
    
    throw Web3Exception('No credentials available');
  }

  void dispose() {
    _client.dispose();
  }
}

// Custom Exception
class Web3Exception implements Exception {
  final String message;
  Web3Exception(this.message);
  
  @override
  String toString() => 'Web3Exception: $message';
}

// Extension Methods for Common Operations
extension Web3ClientExtensions on Web3Client {
  Future<bool> isContractDeployed(String address) async {
    final code = await getCode(EthereumAddress.fromHex(address));
    return code.isNotEmpty;
  }
}
