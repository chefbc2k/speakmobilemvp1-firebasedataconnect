import 'package:flutter/services.dart';

import 'contract_deployment_service.dart';

class NFTContractManager {
  final ContractDeploymentService _deploymentService;
  final String _userId;
  
  NFTContractManager({
    required ContractDeploymentService deploymentService,
    required String userId,
  }) : _deploymentService = deploymentService,
       _userId = userId;

  Future<void> deployNFTContract({
    required String name,
    required String symbol,
    String chain = 'polygon',
  }) async {
    final abi = await rootBundle.loadString('assets/contracts/NFT.json');
    final bytecode = await rootBundle.loadString('assets/contracts/NFT.bin');
    
    return _deploymentService.deployAndLinkContract(
      userId: _userId,
      contractType: 'NFT',
      abi: abi,
      bytecode: bytecode,
      constructorParams: [name, symbol],
      chain: chain,
    );
  }

  Future<void> mintNFT({
    required String contractId,
    required String tokenURI,
    required BigInt price,
  }) async {
    await _deploymentService.executeUserContract(
      userId: _userId,
      contractId: contractId,
      functionName: 'mint',
      params: [tokenURI],
      value: price,
    );
  }
} 