import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.user});

  final User user;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final Map<String, String> _values;

  static const _passwordMask = '**********************';

  @override
  void initState() {
    super.initState();
    _values = {
      'Your full name': widget.user.fullName,
      'Your E-mail': widget.user.email,
      'Your password': _passwordMask,
      'Your mobile number': widget.user.mobileNumber,
      'Your Address': widget.user.address,
    };
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.user.fullName.split(' ').first;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.blueLogo,
            width: 70,
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 18),
          Text('Welcome, $firstName', style: AppTextStyles.header1),
          const SizedBox(height: 5),
          Text(
            _values['Your E-mail']!,
            style: AppTextStyles.general.copyWith(
              color: const Color(0xFF77719D),
            ),
          ),
          const SizedBox(height: 32),
          for (final label in _values.keys) ...[
            Text(label, style: AppTextStyles.header1.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            _ProfileField(
              value: label == 'Your password' ? _passwordMask : _values[label]!,
              onEdit: () => _editField(label),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Future<void> _editField(String label) async {
    final updatedValue = await showDialog<String>(
      context: context,
      builder: (_) => _EditProfileDialog(label: label, value: _values[label]!),
    );
    if (updatedValue != null && updatedValue.isNotEmpty && mounted) {
      setState(() => _values[label] = updatedValue);
    }
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.label, required this.value});

  final String label;
  final String value;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label.replaceFirst('Your ', 'Edit ')),
      content: TextField(
        controller: _controller,
        autofocus: true,
        obscureText: widget.label == 'Your password',
        maxLines: widget.label == 'Your Address' ? 2 : 1,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.value, required this.onEdit});

  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.only(left: 15, right: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.general,
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Edit',
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
