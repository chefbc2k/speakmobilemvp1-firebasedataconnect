import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:speakmobilemvp/features/discover/screens/discover_screen.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/core/models/contract_details.dart';
import 'package:speakmobilemvp/features/discover/screens/contract_details_screen.dart';

class MockContractService extends Mock implements ContractService {
  @override
  Future<ContractDetails> getContractDetails({
    required ContractType contractType,
  }) async {
    // Implement contract fetching logic
    // This should integrate with your blockchain backend
    throw UnimplementedError();
  }

  @override
  Future<void> verifyVoiceContract({
    required String contractId,
  }) async {
    // Implement voice verification logic
    // This should integrate with your voice authentication system
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('tapping smart contract card navigates to details screen',
      (WidgetTester tester) async {
    final mockContractService = MockContractService();
    when(mockContractService.getContractDetails(
      contractType: ContractType.voiceAuthentication,
    )).thenAnswer((_) async => ContractDetails(
      id: '1',
      title: 'Voice Authentication',
      type: ContractType.voiceAuthentication,
      status: 'Verification Pending',
      description: 'Voice authentication contract for verification',
      language: 'en', contractType: '', // Added required language parameter
    ));

    await tester.pumpWidget(MaterialApp(
      home: DiscoverScreen(contractService: mockContractService),
    ));

    await tester.tap(find.text('Voice Authentication'));
    await tester.pumpAndSettle();

    expect(find.byType(ContractDetailsScreen), findsOneWidget);
  });
}
