import 'dart:typed_data';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class ChainConfig {
  final String rpcUrl;
  final int chainId;
  final String name;

  ChainConfig({
    required this.rpcUrl,
    required this.chainId,
    required this.name,
  });
}

class Web3Service {
  final Map<String, Web3Client> _clients = {};
  
  // Chain configurations
  final Map<String, ChainConfig> _chains = {
    'polygon': ChainConfig(
      rpcUrl: 'https://polygon-rpc.com',
      chainId: 137,
      name: 'Polygon Mainnet',
    ),
    'mumbai': ChainConfig(
      rpcUrl: 'https://rpc-mumbai.maticvigil.com',
      chainId: 80001,
      name: 'Polygon Mumbai Testnet',
    ),
    // Add other chains as needed
  };

  Web3Service() {
    _initializeClients();
  }

  void _initializeClients() {
    for (final entry in _chains.entries) {
      final client = Web3Client(
        entry.value.rpcUrl,
        http.Client(),
      );
      _clients[entry.key] = client;
    }
  }

  /// Gets the credentials for the current user or wallet
  Future<Credentials> getCredentials() async {
    try {
      // For development, you might want to use a private key
      // In production, integrate with a proper wallet solution
      final privateKey = EthPrivateKey.fromHex(
        'your_private_key_here' // Replace with secure key management
      );
      return privateKey;
    } catch (e) {
      throw Web3Exception('Failed to get credentials: ${e.toString()}');
    }
  }

  Future<String> deploySmartContract(
    String abi,
    String bytecode,
    List<dynamic> constructorParams, {
    String? privateKey,
    String chain = 'polygon',
  }) async {
    try {
      final client = _clients[chain];
      if (client == null) {
        throw Web3Exception('Chain not supported: $chain');
      }

      final credentials = privateKey != null 
          ? EthPrivateKey.fromHex(privateKey)
          : await getCredentials();

      final contractAbi = ContractAbi.fromJson(abi, 'DynamicContract');
      
      // Encode constructor parameters
      final constructorData = hexToBytes(
        contractAbi.functions
            .firstWhere((f) => f.isConstructor)
            .encodeCall(constructorParams)
            .asString()
            .substring(2) // Remove '0x' prefix
      );
      
      // Use the new method to prepare deployment data
      final deployData = _prepareDeploymentData(bytecode, constructorData);

      final transaction = Transaction(
        from: credentials.address,
        data: deployData,
        maxGas: 2000000, // Adjust as needed
      );

      final deployHash = await client.sendTransaction(
        credentials,
        transaction,
        chainId: _chains[chain]!.chainId,
      );

      // Wait for deployment receipt
      final receipt = await client.getTransactionReceipt(deployHash);
      if (receipt == null || receipt.contractAddress == null) {
        throw Web3Exception('Contract deployment failed');
      }

      return receipt.contractAddress!.hex;
    } catch (e) {
      throw Web3Exception('Failed to deploy contract: ${e.toString()}');
    }
  }

  Future<String> executeTransaction({
    required String contractAddress,
    required String functionName,
    required List<dynamic> params,
    required Credentials credentials,
    BigInt? value,
    String chain = 'polygon',
  }) async {
    try {
      final client = _clients[chain];
      if (client == null) {
        throw Web3Exception('Chain not supported: $chain');
      }

      final contract = await _getContract(contractAddress);
      final function = contract.function(functionName);

      final transaction = Transaction.callContract(
        contract: contract,
        function: function,
        parameters: params,
        maxGas: 2000000, // Adjust as needed
        value: value != null ? EtherAmount.inWei(value) : null,
      );

      return await client.sendTransaction(
        credentials,
        transaction,
        chainId: _chains[chain]!.chainId,
      );
    } catch (e) {
      throw Web3Exception('Transaction failed: ${e.toString()}');
    }
  }

  Future<DeployedContract> _getContract(String address) async {
    // Implementation for getting contract ABI and creating DeployedContract
    throw UnimplementedError('Contract loading not implemented');
  }

  // Create a separate method for handling deployment data
  Uint8List _prepareDeploymentData(String bytecode, Uint8List constructorData) {
    try {
      // Clean bytecode if needed
      final cleanBytecode = bytecode.startsWith('0x') 
          ? hexToBytes(bytecode.substring(2))
          : hexToBytes(bytecode);
      
      // Combine bytecode and constructor data with proper error handling
      return Uint8List.fromList([...cleanBytecode, ...constructorData]);
    } catch (e) {
      throw Web3Exception('Failed to prepare deployment data: ${e.toString()}');
    }
  }
}

extension on Uint8List {
  asString() {}
}

class Web3Exception implements Exception {
  final String message;
  Web3Exception(this.message);

  @override
  String toString() => 'Web3Exception: $message';
}
