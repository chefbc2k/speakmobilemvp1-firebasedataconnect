import 'package:supabase_flutter/supabase_flutter.dart';

import '../frontend/web3_service.dart';


class ContractDeploymentService {
  final Web3Service _web3Service;
  final SupabaseClient _supabase;
  
  ContractDeploymentService({
    required Web3Service web3Service,
    required SupabaseClient supabase,
  }) : _web3Service = web3Service,
       _supabase = supabase;

  Future<void> deployAndLinkContract({
    required String userId,
    required String contractType,
    required String abi,
    required String bytecode,
    required List<dynamic> constructorParams,
    required String chain,
    String? privateKey,
  }) async {
    try {
      // Deploy the contract using the correct method name
      final contractAddress = await _web3Service.deploySmartContract(
        abi,
        bytecode,
        constructorParams,
        privateKey: privateKey,
        chain: chain,
      );

      // Store contract information in database
      await _supabase.from('user_contracts').insert({
        'user_id': userId,
        'contract_address': contractAddress,
        'contract_type': contractType,
        'chain': chain,
        'abi': abi,
        'deployed_at': DateTime.now().toIso8601String(),
        'constructor_params': constructorParams,
      });
    } catch (e) {
      throw ContractDeploymentException(
        'Failed to deploy contract: ${e.toString()}'
      );
    }
  }

  Future<List<UserContract>> getUserContracts(String userId) async {
    try {
      final response = await _supabase
        .from('user_contracts')
        .select()
        .eq('user_id', userId);

      return (response as List)
        .map((data) => UserContract.fromJson(data))
        .toList();
    } catch (e) {
      throw ContractQueryException(
        'Failed to fetch user contracts: ${e.toString()}'
      );
    }
  }

  Future<void> executeUserContract({
    required String userId,
    required String contractId,
    required String functionName,
    required List<dynamic> params,
    BigInt? value,
  }) async {
    try {
      // Get contract details from database
      final contract = await _supabase
        .from('user_contracts')
        .select()
        .eq('id', contractId)
        .eq('user_id', userId)
        .single();

      // Get credentials using the new public method
      final credentials = await _web3Service.getCredentials();

      // Execute the contract function with required credentials
      await _web3Service.executeTransaction(
        contractAddress: contract['contract_address'],
        functionName: functionName,
        params: params,
        credentials: credentials,
        value: value,
        chain: contract['chain'],
      );
    } catch (e) {
      throw ContractExecutionException(
        'Failed to execute contract: ${e.toString()}'
      );
    }
  }
}

// Models
class UserContract {
  final String id;
  final String userId;
  final String contractAddress;
  final String contractType;
  final String chain;
  final String abi;
  final DateTime deployedAt;
  final List<dynamic> constructorParams;

  UserContract({
    required this.id,
    required this.userId,
    required this.contractAddress,
    required this.contractType,
    required this.chain,
    required this.abi,
    required this.deployedAt,
    required this.constructorParams,
  });

  factory UserContract.fromJson(Map<String, dynamic> json) {
    return UserContract(
      id: json['id'],
      userId: json['user_id'],
      contractAddress: json['contract_address'],
      contractType: json['contract_type'],
      chain: json['chain'],
      abi: json['abi'],
      deployedAt: DateTime.parse(json['deployed_at']),
      constructorParams: json['constructor_params'],
    );
  }
}
// Custom exceptions
class ContractDeploymentException implements Exception {
  final String message;
  ContractDeploymentException(this.message);
}

class ContractQueryException implements Exception {
  final String message;
  ContractQueryException(this.message);
}

class ContractExecutionException implements Exception {
  final String message;
  ContractExecutionException(this.message);
}

class ContractNotFoundException implements Exception {
  final String message;
  ContractNotFoundException(this.message);
}
