import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class ChainConfig {
  final int chainId;
  final String rpcUrl;
  final String name;
  final String symbol;
  final int decimals;

  const ChainConfig({
    required this.chainId,
    required this.rpcUrl,
    required this.name,
    required this.symbol,
    required this.decimals,
  });
}

class Web3Service {
  final Map<String, ChainConfig> _chains;
  final Map<String, Web3Client> _clients = {};
  final Map<String, DeployedContract> _contractCache = {};
  String _currentChain;
  
  Web3Service({
    required Map<String, ChainConfig> chains,
    String defaultChain = 'polygon',
  }) : _chains = chains,
       _currentChain = defaultChain {
    for (var entry in chains.entries) {
      _clients[entry.key] = Web3Client(
        entry.value.rpcUrl,
        http.Client(),
      );
    }
  }

  Future<void> _switchChain(String chain) async {
    if (!_chains.containsKey(chain)) {
      throw Exception('Unsupported chain: $chain');
    }
    _currentChain = chain;
  }

  Future<Credentials> _getCredentials() async {
    // Implement your wallet connection logic here
    // This is just a placeholder
    throw UnimplementedError('Wallet connection not implemented');
  }

  Future<String> deployContract(
    String abi,
    String bytecode,
    List<dynamic> constructorParams, {
    String? privateKey,
    String chain = 'polygon',
  }) async {
    if (_currentChain != chain) {
      await _switchChain(chain);
    }

    final client = _clients[chain]!;
    final credentials = privateKey != null 
      ? EthPrivateKey.fromHex(privateKey)
      : await _getCredentials();

    // Create contract instance for deployment
    final contractAbi = ContractAbi.fromJson(abi, 'DynamicContract');
    
    // Find the constructor function
    final constructor = contractAbi.functions
        .firstWhere((f) => f.isConstructor);
    
    // Encode constructor parameters
    final encodedParams = constructor.encodeCall(constructorParams);
    
    // Combine bytecode with encoded constructor parameters
    final deployData = bytecode + bytesToHex(encodedParams, include0x: false);

    // Create deployment transaction
    final transaction = Transaction(
      from: credentials.address,
      data: hexToBytes(deployData),
      maxGas: 2000000, // Adjust gas limit as needed
    );

    final deployment = await client.sendTransaction(
      credentials,
      transaction,
      chainId: _chains[chain]!.chainId,
    );

    final receipt = await client.getTransactionReceipt(deployment);
    if (receipt == null || receipt.contractAddress == null) {
      throw Exception('Contract deployment failed');
    }

    return receipt.contractAddress!.hex;
  }

  Future<dynamic> executeContract(
    String contractAddress,
    String abi,
    String functionName,
    List<dynamic> params, {
    String? privateKey,
    String chain = 'polygon',
    BigInt? value,
  }) async {
    if (_currentChain != chain) {
      await _switchChain(chain);
    }

    final contractKey = '$chain:$contractAddress';
    final contract = _contractCache[contractKey] ?? DeployedContract(
      ContractAbi.fromJson(abi, 'DynamicContract'),
      EthereumAddress.fromHex(contractAddress),
    );
    _contractCache[contractKey] = contract;

    final function = contract.function(functionName);
    final credentials = privateKey != null 
      ? EthPrivateKey.fromHex(privateKey)
      : await _getCredentials();

    final transaction = Transaction.callContract(
      contract: contract,
      function: function,
      parameters: params,
      value: value != null ? EtherAmount.fromBigInt(EtherUnit.wei, value) : null,
    );

    final result = await _clients[chain]!.sendTransaction(
      credentials,
      transaction,
      chainId: _chains[chain]!.chainId,
    );

    return result;
  }

  Future<List<dynamic>> readContract(
    String contractAddress,
    String abi,
    String functionName,
    List<dynamic> params, {
    String chain = 'polygon',
  }) async {
    if (_currentChain != chain) {
      await _switchChain(chain);
    }

    final contractKey = '$chain:$contractAddress';
    final contract = _contractCache[contractKey] ?? DeployedContract(
      ContractAbi.fromJson(abi, 'DynamicContract'),
      EthereumAddress.fromHex(contractAddress),
    );
    _contractCache[contractKey] = contract;

    final function = contract.function(functionName);
    final result = await _clients[chain]!.call(
      contract: contract,
      function: function,
      params: params,
    );

    return result;
  }

  void dispose() {
    for (var client in _clients.values) {
      client.dispose();
    }
  }
}

// Optional: Contract Manager for handling contract-specific logic
class ContractManager {
  final Web3Service _web3Service;
  final String _contractAddress;
  final String _abi;
  final String _chain;

  ContractManager({
    required Web3Service web3Service,
    required String contractAddress,
    required String abi,
    String chain = 'polygon',
  }) : _web3Service = web3Service,
       _contractAddress = contractAddress,
       _abi = abi,
       _chain = chain;

  Future<dynamic> execute(
    String functionName,
    List<dynamic> params, {
    String? privateKey,
    BigInt? value,
  }) async {
    return _web3Service.executeContract(
      _contractAddress,
      _abi,
      functionName,
      params,
      privateKey: privateKey,
      chain: _chain,
      value: value,
    );
  }

  Future<List<dynamic>> read(
    String functionName,
    List<dynamic> params,
  ) async {
    return _web3Service.readContract(
      _contractAddress,
      _abi,
      functionName,
      params,
      chain: _chain,
    );
  }
}
