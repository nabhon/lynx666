import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import 'widgets/bet_history_tile.dart';

class BetHistoryScreen extends ConsumerStatefulWidget {
  const BetHistoryScreen({super.key});

  @override
  ConsumerState<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends ConsumerState<BetHistoryScreen> {
  BetStatus? _filter;

  List<Bet> _getFilteredBets() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final bets = _getFilteredBets();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 24),
            SizedBox(width: 8),
            Text('ประวัติการแทง', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFFFB627),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: _buildFilters(),
        ),
      ),
      body: bets.isEmpty
          ? const Center(child: Text('ยังไม่มีประวัติการแทง'))
          : _buildListView(bets),
    );
  }

  Widget _buildListView(List<Bet> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: data.length,
      itemBuilder: (_, i) => BetHistoryTile(bet: data[i]),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 52,
      color: const Color(0xFFFFB627),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(child: _chip('ทั้งหมด', null)),
          const SizedBox(width: 6),
          Expanded(child: _chip('รอผล', BetStatus.pending)),
          const SizedBox(width: 6),
          Expanded(child: _chip('ถูกรางวัล', BetStatus.won)),
          const SizedBox(width: 6),
          Expanded(child: _chip('ไม่ถูก', BetStatus.lost)),
        ],
      ),
    );
  }

  Widget _chip(String label, BetStatus? status) {
    final isSelected = _filter == status;
    return GestureDetector(
      onTap: () => setState(() => _filter = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFFFFB627) : Colors.white,
          ),
        ),
      ),
    );
  }
}
