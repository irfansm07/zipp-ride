import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

// ----------------------------------------------------------------------
// 1. Personal Info Screen
// ----------------------------------------------------------------------
class PersonalInfoScreen extends StatelessWidget {
  final String userName;

  const PersonalInfoScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Personal Info', style: AppTheme.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoTile('Full Name', userName, Icons.person_outline),
            _buildInfoTile('Phone Number', '+91 93477 02626', Icons.phone_outlined),
            _buildInfoTile('Email Address', 'smirfan9247@gmail.com', Icons.email_outlined),
            _buildInfoTile('Gender', 'Male', Icons.wc_outlined),
            _buildInfoTile('Date of Birth', '15 Aug 1998', Icons.cake_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showEditProfileSheet(context, userName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Profile', style: AppTheme.heading2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildEditTextField('Full Name', currentName, Icons.person_outline),
              const SizedBox(height: 16),
              _buildEditTextField('Phone Number', '+91 93477 02626', Icons.phone_outlined),
              const SizedBox(height: 16),
              _buildEditTextField('Email Address', 'smirfan9247@gmail.com', Icons.email_outlined),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully! ✨'),
                        backgroundColor: AppColors.teal,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditTextField(String label, String initialVal, IconData icon) {
    return TextField(
      controller: TextEditingController(text: initialVal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: Icon(icon, color: AppColors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.cardBorder.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.teal, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.caption),
                  const SizedBox(height: 4),
                  Text(value, style: AppTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 2. Payment Methods Screen
// ----------------------------------------------------------------------
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Payment Methods', style: AppTheme.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Payment', style: AppTheme.heading3),
            const SizedBox(height: 12),
            GlassCard(
              isGlowing: true,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UPI (PhonePe)', style: AppTheme.bodyMedium),
                        Text('Mar 1, 11:00 AM', style: AppTheme.caption),
                      ],
                    ),
                  ),
                  Text('₹279', style: AppTheme.heading2.copyWith(color: AppColors.success)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Available Methods', style: AppTheme.heading3),
            const SizedBox(height: 12),
            _buildPaymentMethodTile('cash', 'Cash', 'Pay driver directly', Icons.money_rounded, AppColors.success),
            _buildPaymentMethodTile('upi', 'Add New UPI', 'GPay, PhonePe, Paytm', Icons.qr_code_2_rounded, AppColors.teal),
            _buildPaymentMethodTile('card', 'Credit/Debit Card', 'Visa, Mastercard, RuPay', Icons.credit_card_rounded, AppColors.amber),
            _buildPaymentMethodTile('wallet', 'Zipp Wallet', 'Balance: ₹0', Icons.account_balance_wallet_rounded, AppColors.pink),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(String id, String title, String subtitle, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 3. Safety Screen (SOS Logic)
// ----------------------------------------------------------------------
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  // Mocking persistence using a static variable so it lasts while the app is alive
  static String? savedEmergencyNumber;

  void _handleSOSClick() {
    if (savedEmergencyNumber == null) {
      // First time click: Ask for number
      _showSetupDialog();
    } else {
      // Subsequent clicks: Trigger immediate SOS alert
      _triggerActiveSOSAlert();
    }
  }

  void _showSetupDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Setup Emergency SOS', style: AppTheme.heading3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter an emergency contact number. An alert will be sent to this number when you press SOS during a ride.',
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    savedEmergencyNumber = controller.text;
                  });
                  Navigator.pop(context);
                  _triggerActiveSOSAlert(); // Trigger the alert immediately after setup!
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save & Alert', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _triggerActiveSOSAlert() {
    // Show a critical simulated loud alert and notification trigger
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.pink.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.pink, width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.pink, size: 64),
              const SizedBox(height: 16),
              Text('SOS TRIGGERED!', style: AppTheme.heading2.copyWith(color: AppColors.pink)),
              const SizedBox(height: 8),
              Text(
                '[LOUD ALARM SOUNDING]\n\nEmergency alert and live location sent to: $savedEmergencyNumber.',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('DISMISS ALARM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Safety Options', style: AppTheme.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The massive SOS button
            GestureDetector(
              onTap: _handleSOSClick,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF4D6D), Color(0xFFD90429)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Icon(Icons.emergency_share_rounded, size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SOS EMERGENCY',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      savedEmergencyNumber == null 
                        ? 'Tap to Setup Contact' 
                        : 'Tap to alert $savedEmergencyNumber',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Safety Features', style: AppTheme.heading3),
            const SizedBox(height: 16),
            _buildSafetyTile('Share Trip', 'Share live location with loved ones', Icons.share_location_rounded),
            _buildSafetyTile('Audio Recording', 'Record audio securely during rides', Icons.mic_rounded),
            _buildSafetyTile('Ride Check', 'We regularly check on unusual stops', Icons.route_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTile(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.teal, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.bodyMedium),
                  Text(subtitle, style: AppTheme.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 4. Notifications Screen
// ----------------------------------------------------------------------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'App Update Available',
        'desc': 'Update to ZippApp v2.2 for faster book loading.',
        'time': '2 hours ago',
        'icon': Icons.system_update_rounded,
        'color': AppColors.blue,
      },
      {
        'title': 'New Coupon Added! 🎁',
        'desc': 'You have received a 50% discount on your next 3 rides.',
        'time': 'Yesterday',
        'icon': Icons.local_offer_rounded,
        'color': AppColors.amber,
      },
      {
        'title': 'Ride Completed',
        'desc': 'Thanks for riding with Deepak. Your bill was ₹279.',
        'time': 'Mar 1',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.success,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notifications', style: AppTheme.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notice = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: (notice['color'] as Color).withValues(alpha: 0.1),
                  child: Icon(notice['icon'] as IconData, color: notice['color'] as Color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notice['title'] as String, style: AppTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text(notice['desc'] as String, style: AppTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text(notice['time'] as String, style: AppTheme.caption.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 5. Help & Support Screen
// ----------------------------------------------------------------------
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Help & Support', style: AppTheme.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://cdn3d.iconscout.com/3d/premium/thumb/customer-service-5163013-4328571.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.support_agent_rounded, size: 100, color: AppColors.teal),
              ),
            ),
            const SizedBox(height: 24),
            Text('Contact Us', style: AppTheme.heading2),
            const SizedBox(height: 16),
            _buildContactTile('Email Support', 'smirfan9247@gmail.com', Icons.email_rounded),
            _buildContactTile('Phone Support', '+91 93477 02626', Icons.phone_rounded),
            
            const SizedBox(height: 32),
            Text('Quick Actions', style: AppTheme.heading3),
            const SizedBox(height: 16),
            
            // Complaint about last ride block
            GlassCard(
              padding: const EdgeInsets.all(16),
              isGlowing: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.report_problem_rounded, color: AppColors.amber),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Feedback / Complaint', style: AppTheme.bodyMedium),
                        Text('Report issue with your last ride.', style: AppTheme.caption),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Support ticket raised for last ride.')),
                       );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Open', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildFaqTile('Lost an item during my ride'),
            _buildFaqTile('My promo code didn\'t apply'),
            _buildFaqTile('Change my account details'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.teal, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.caption),
                  Text(value, style: AppTheme.bodyMedium.copyWith(color: AppColors.teal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(question, style: AppTheme.bodySmall.copyWith(color: AppColors.darkGrey))),
            const Icon(Icons.keyboard_arrow_right_rounded, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
