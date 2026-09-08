import 'package:flutter/material.dart';
import '../models/exchange_rate.dart';
import '../services/currency_api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final CurrencyApiService _apiService = CurrencyApiService();

  // ==========================================================================
  // 🌟 BEST PRACTICE: Store the Future in a state variable!
  // Do NOT write: FutureBuilder(future: _apiService.fetchLiveExchangeRates())
  // directly in the build() method, otherwise every setState() or animation
  // will refetch the API repeatedly!
  // ==========================================================================
  late Future<List<CurrencyRate>> _ratesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  void _loadRates() {
    _ratesFuture = _apiService.fetchLiveExchangeRates(base: 'USD');
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _loadRates();
    });
    // Await the new future so RefreshIndicator spinner stops when complete
    await _ratesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Currency Rates',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF818CF8)),
            onPressed: () {
              setState(() {
                _loadRates();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search currency (e.g., EUR, GBP, JPY)...',
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF818CF8)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Live Rates List via FutureBuilder + Pull to Refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFF1E293B),
              child: FutureBuilder<List<CurrencyRate>>(
                future: _ratesFuture,
                builder: (context, snapshot) {
                  // ==========================================================
                  // 1. STATE: LOADING / WAITING
                  // ==========================================================
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  }

                  // ==========================================================
                  // 2. STATE: ERROR (Network failure, timeout, 404/500, etc.)
                  // ==========================================================
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  // ==========================================================
                  // 3. STATE: EMPTY DATA
                  // ==========================================================
                  final List<CurrencyRate>? rates = snapshot.data;
                  if (rates == null || rates.isEmpty) {
                    return _buildEmptyState('No exchange rate data available.');
                  }

                  // Filter by user search query
                  final filteredRates = rates.where((r) {
                    final q = _searchQuery.toLowerCase();
                    return r.code.toLowerCase().contains(q) ||
                        r.name.toLowerCase().contains(q);
                  }).toList();

                  if (filteredRates.isEmpty) {
                    return _buildEmptyState('No currencies match "$_searchQuery"');
                  }

                  // ==========================================================
                  // 4. STATE: SUCCESS (Data ready to render)
                  // ==========================================================
                  return _buildRatesList(filteredRates);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // UI Sub-builder: Success List
  // --------------------------------------------------------------------------
  Widget _buildRatesList(List<CurrencyRate> rates) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: rates.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final rate = rates[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
          ),
          child: Row(
            children: [
              // Country Flag Emoji / Icon
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(rate.flag, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              // Currency Code & Full Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rate.code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rate.name,
                      style: const TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              // Rate value relative to 1 USD
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rate.rate.toStringAsFixed(4),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '1 USD =',
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // UI Sub-builder: Loading State
  // --------------------------------------------------------------------------
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
          SizedBox(height: 16),
          Text(
            'Fetching live exchange rates...',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // UI Sub-builder: Error State (With Retry Action)
  // --------------------------------------------------------------------------
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Oops! Failed to load data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => setState(() => _loadRates()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // UI Sub-builder: Empty State
  // --------------------------------------------------------------------------
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.white38),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
