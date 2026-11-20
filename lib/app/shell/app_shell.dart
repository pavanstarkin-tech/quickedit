import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/token_storage.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/models/editor_model.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/booking_model.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/client_dashboard/presentation/client_home_screen.dart';
import '../../features/browse_editors/presentation/browse_editors_screen.dart';
import '../../features/editor_profile/presentation/editor_profile_screen.dart';
import '../../features/booking/presentation/booking_wizard_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/order_tracking/presentation/order_tracking_screen.dart';
import '../../features/editor_dashboard/presentation/editor_dashboard_screen.dart';
import '../../features/job_requests/presentation/job_requests_screen.dart';
import '../../features/project_workspace/presentation/project_workspace_screen.dart';
import '../../features/calendar/presentation/editor_calendar_screen.dart';
import '../../features/earnings/presentation/editor_earnings_screen.dart';
import '../../features/clients_support/presentation/clients_support_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _showRegister = false;

  int _clientNavIndex = 0; // 0: Home, 1: Explore, 2: Orders, 3: Chat, 4: Profile
  int _editorNavIndex = 0; // 0: Dashboard, 1: Jobs, 2: Calendar, 3: Clients, 4: Earnings

  // In-flow state holders
  EditorModel? _viewingEditor;
  ServiceModel? _bookingService;
  BookingModel? _activeOrder;
  Map<String, dynamic>? _checkoutData;
  bool _isInBookingFlow = false;
  bool _isInCheckoutFlow = false;
  bool _isInWorkspaceFlow = false;

  @override
  Widget build(BuildContext context) {
    final session = TokenStorage.currentSession;

    // Unauthenticated State: Show Login or Register Screen
    if (session == null) {
      if (_showRegister) {
        return RegisterScreen(
          onRegisterSuccess: () => setState(() {}),
          onSwitchToLogin: () => setState(() => _showRegister = false),
        );
      }
      return LoginScreen(
        onLoginSuccess: () => setState(() {}),
        onSwitchToRegister: () => setState(() => _showRegister = true),
      );
    }

    final isEditor = session.role == UserRole.editor;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      // Authenticated Top Bar showing User Session & Active Role
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: AppColors.deepBlack,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 4,
            left: 16,
            right: 16,
            bottom: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User identity & Role badge
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                      session.avatarUrl ??
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.fullName,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: isEditor ? AppColors.primaryOrange : AppColors.secondaryOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      session.role.displayName.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // Actions (Switch Role / Logout)
              Row(
                children: [
                  if (_viewingEditor != null || _isInBookingFlow || _isInCheckoutFlow || _isInWorkspaceFlow) ...[
                    GestureDetector(
                      onTap: _resetSubFlows,
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Text('Back', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                  // Quick Switch Role button
                  GestureDetector(
                    onTap: _toggleRole,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isEditor ? 'Switch to Client' : 'Switch to Editor',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Logout
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white70, size: 18),
                    tooltip: 'Log Out',
                    onPressed: () async {
                      await AuthService.logout();
                      setState(() {
                        _resetSubFlows();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _buildCurrentRoleBody(session.role),
      bottomNavigationBar: _buildBottomNav(session.role),
    );
  }

  void _toggleRole() {
    final current = TokenStorage.currentSession;
    if (current == null) return;
    final nextRole = current.role == UserRole.client ? UserRole.editor : UserRole.client;
    final newSession = UserSession(
      id: nextRole == UserRole.editor ? 3 : 1,
      email: nextRole == UserRole.editor ? 'rohan.mehta@quickedit.dev' : 'maya.patel@quickedit.dev',
      fullName: nextRole == UserRole.editor ? 'Rohan Mehta' : 'Maya Patel',
      avatarUrl: nextRole == UserRole.editor
          ? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'
          : 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
      role: nextRole,
      token: current.token,
    );
    TokenStorage.saveSession(newSession);
    _resetSubFlows();
  }

  void _resetSubFlows() {
    setState(() {
      _viewingEditor = null;
      _bookingService = null;
      _isInBookingFlow = false;
      _isInCheckoutFlow = false;
      _isInWorkspaceFlow = false;
    });
  }

  Widget _buildCurrentRoleBody(UserRole role) {
    if (role == UserRole.editor) {
      if (_isInWorkspaceFlow) {
        return ProjectWorkspaceScreen(onBack: () => setState(() => _isInWorkspaceFlow = false));
      }
      switch (_editorNavIndex) {
        case 0:
          return EditorDashboardScreen(
            onNavigate: (r) {
              if (r == '/job-requests') setState(() => _editorNavIndex = 1);
              if (r == '/calendar') setState(() => _editorNavIndex = 2);
              if (r == '/earnings') setState(() => _editorNavIndex = 4);
            },
          );
        case 1:
          return JobRequestsScreen(
            onOpenWorkspace: (job) => setState(() => _isInWorkspaceFlow = true),
          );
        case 2:
          return const EditorCalendarScreen();
        case 3:
          return ClientsSupportScreen(
            onNavigate: (r) => setState(() => _isInWorkspaceFlow = true),
          );
        case 4:
          return const EditorEarningsScreen();
        default:
          return const EditorDashboardScreen();
      }
    }

    // Client Role Flows
    if (_isInCheckoutFlow && _checkoutData != null) {
      return CheckoutScreen(
        editor: _checkoutData!['editor'],
        service: _checkoutData!['service'],
        addons: _checkoutData!['addons'],
        totalAmount: _checkoutData!['total'],
        onBack: () => setState(() => _isInCheckoutFlow = false),
        onPaymentSuccess: () {
          setState(() {
            _isInCheckoutFlow = false;
            _isInBookingFlow = false;
            _activeOrder = MockData.activeBookings.first;
            _clientNavIndex = 2; // Jump to Orders screen
          });
        },
      );
    }

    if (_isInBookingFlow) {
      return BookingWizardScreen(
        preselectedEditor: _viewingEditor ?? MockData.editors.first,
        preselectedService: _bookingService ?? MockData.services[1],
        onBack: () => setState(() => _isInBookingFlow = false),
        onProceedToCheckout: (data) {
          setState(() {
            _checkoutData = data;
            _isInCheckoutFlow = true;
          });
        },
      );
    }

    if (_viewingEditor != null) {
      return EditorProfileScreen(
        editor: _viewingEditor!,
        onBack: () => setState(() => _viewingEditor = null),
        onBookNow: () => setState(() => _isInBookingFlow = true),
      );
    }

    switch (_clientNavIndex) {
      case 0:
        return ClientHomeScreen(
          onNavigate: (r) {
            if (r == '/browse') setState(() => _clientNavIndex = 1);
          },
          onSelectEditor: (ed) => setState(() => _viewingEditor = ed),
          onSelectService: (srv) {
            setState(() {
              _bookingService = srv;
              _isInBookingFlow = true;
            });
          },
        );
      case 1:
        return BrowseEditorsScreen(
          onSelectEditor: (ed) => setState(() => _viewingEditor = ed),
        );
      case 2:
        return OrderTrackingScreen(
          booking: _activeOrder ?? MockData.activeBookings.first,
        );
      case 3:
        return ClientsSupportScreen(
          onNavigate: (r) => setState(() => _clientNavIndex = 2),
        );
      case 4:
        return const EditorEarningsScreen();
      default:
        return const ClientHomeScreen();
    }
  }

  Widget? _buildBottomNav(UserRole role) {
    if (_isInBookingFlow || _isInCheckoutFlow || _viewingEditor != null || _isInWorkspaceFlow) {
      return null;
    }

    final isEditor = role == UserRole.editor;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepBlack,
        border: Border(top: BorderSide(color: Color(0xFF202020))),
      ),
      child: SafeArea(
        top: false,
        child: Theme(
          data: ThemeData(canvasColor: AppColors.deepBlack),
          child: BottomNavigationBar(
            backgroundColor: AppColors.deepBlack,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryOrange,
            unselectedItemColor: const Color(0xFF858585),
            currentIndex: isEditor ? _editorNavIndex : _clientNavIndex,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            onTap: (index) {
              setState(() {
                if (isEditor) {
                  _editorNavIndex = index;
                } else {
                  _clientNavIndex = index;
                }
              });
            },
            items: isEditor
                ? const [
                    BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
                    BottomNavigationBarItem(icon: Icon(Icons.mark_email_unread_outlined), activeIcon: Icon(Icons.mark_email_unread), label: 'Jobs'),
                    BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Calendar'),
                    BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Clients'),
                    BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
                  ]
                : const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
                    BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Orders'),
                    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
                  ],
          ),
        ),
      ),
    );
  }
}
