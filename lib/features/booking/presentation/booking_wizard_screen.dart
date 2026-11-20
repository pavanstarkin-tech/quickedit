import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/editor_model.dart';
import '../../../shared/models/service_model.dart';

class BookingWizardScreen extends StatefulWidget {
  final EditorModel? preselectedEditor;
  final ServiceModel? preselectedService;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> bookingSummary)? onProceedToCheckout;

  const BookingWizardScreen({
    super.key,
    this.preselectedEditor,
    this.preselectedService,
    this.onBack,
    this.onProceedToCheckout,
  });

  @override
  State<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends State<BookingWizardScreen> {
  int _currentStep = 1; // 1: Service, 2: Upload, 3: Details, 4: Payment summary

  late ServiceModel _selectedService;
  late EditorModel _selectedEditor;

  final TextEditingController _briefController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _referenceLinkController = TextEditingController();

  final List<ServiceAddon> _selectedAddons = [];

  // Mock Uploaded Files with progress (Screen 04)
  final List<Map<String, dynamic>> _uploadedFiles = [
    {
      'name': 'IMG_8921.MOV',
      'size': '320 MB',
      'progress': 1.0,
      'status': 'Done',
    },
    {
      'name': 'voiceover.mp3',
      'size': '12 MB',
      'progress': 1.0,
      'status': 'Done',
    },
    {
      'name': 'broll_clip.zip',
      'size': '850 MB',
      'progress': 0.65,
      'status': 'Uploading 65%...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedEditor = widget.preselectedEditor ?? MockData.editors.first;
    _selectedService = widget.preselectedService ?? MockData.services[1]; // Insta Reel
  }

  double get _totalPrice {
    double total = _selectedService.defaultBasePrice;
    for (var a in _selectedAddons) {
      total += a.price;
    }
    return total;
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        for (final file in result.files) {
          final sizeMb = (file.size / (1024 * 1024)).toStringAsFixed(1);
          setState(() {
            _uploadedFiles.add({
              'name': file.name,
              'size': '$sizeMb MB',
              'progress': 1.0,
              'status': 'Uploaded (R2 Ready)',
            });
          });
        }
      }
    } catch (_) {
      // Fallback if browser/emulator denies permissions
      setState(() {
        _uploadedFiles.add({
          'name': 'raw_footage_clip_${_uploadedFiles.length + 1}.mov',
          'size': '420 MB',
          'progress': 1.0,
          'status': 'Uploaded (R2 Ready)',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              widget.onBack != null ? widget.onBack!() : Navigator.maybePop(context);
            }
          },
        ),
        title: Text('Create Booking', style: AppTypography.titleLarge()),
      ),
      body: Column(
        children: [
          // 4-Step Stepper Header (Screen 04)
          _buildStepperHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Action Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    final steps = ['Service', 'Upload', 'Details', 'Payment'];

    return Container(
      color: AppColors.surfaceWhite,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final stepNum = index + 1;
          final isActive = _currentStep == stepNum;
          final isPassed = _currentStep > stepNum;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isPassed
                        ? AppColors.successGreen
                        : (isActive ? AppColors.primaryOrange : AppColors.warmCream),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppColors.primaryOrange : AppColors.lightBorder,
                    ),
                  ),
                  child: Center(
                    child: isPassed
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '$stepNum',
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.textDark : AppColors.mutedGray,
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: isPassed ? AppColors.successGreen : AppColors.lightBorder,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1Service();
      case 2:
        return _buildStep2Upload();
      case 3:
        return _buildStep3Details();
      case 4:
        return _buildStep4Summary();
      default:
        return const SizedBox();
    }
  }

  // Step 1: 3x2 Service Card Grid
  Widget _buildStep1Service() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Video Service', style: AppTypography.titleLarge()),
        const SizedBox(height: 6),
        Text(
          'Choose the format for your project with ${_selectedEditor.name}',
          style: AppTypography.bodySmall(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.25,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, i) {
            final service = MockData.services[i];
            final isSelected = _selectedService.id == service.id;

            return InkWell(
              onTap: () => setState(() => _selectedService = service),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryOrange : AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryOrange : AppColors.lightBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.movie_creation_outlined,
                          color: isSelected ? Colors.white : AppColors.primaryOrange,
                        ),
                        Text(
                          CurrencyFormatter.format(service.defaultBasePrice),
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.subtitle,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : AppColors.mutedGray,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Step 2: Upload Raw Media up to 2GB (Screen 04)
  Widget _buildStep2Upload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Raw Footage & Assets', style: AppTypography.titleLarge()),
        const SizedBox(height: 4),
        Text('Upload clips, voiceovers, music, brand kits (up to 2 GB per file).', style: AppTypography.bodySmall()),
        const SizedBox(height: 16),

        // Dashed Dropzone
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryOrange.withOpacity(0.5),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.warmCream,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primaryOrange, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'Drag & drop files here or Browse Files',
                style: AppTypography.titleMedium(),
              ),
              const SizedBox(height: 4),
              Text(
                'MP4, MOV, AVI, JPG, PNG, ZIP — Max 2GB each',
                style: AppTypography.bodySmall(color: AppColors.mutedGray),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.add),
                label: const Text('Add File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

        const SizedBox(height: 24),
        Text('Uploaded Files (${_uploadedFiles.length})', style: AppTypography.titleMedium()),
        const SizedBox(height: 12),

        // File Progress List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _uploadedFiles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final f = _uploadedFiles[i];
            final double prog = f['progress'];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insert_drive_file_outlined, color: AppColors.primaryOrange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['name'], style: AppTypography.labelLarge(color: AppColors.textDark)),
                            Text('${f['size']} • ${f['status']}', style: AppTypography.bodySmall()),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _uploadedFiles.removeAt(i)),
                      ),
                    ],
                  ),
                  if (prog < 1.0) ...[
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: prog,
                      backgroundColor: AppColors.warmCream,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Step 3: Brief, Reference Link, Add-ons
  Widget _buildStep3Details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Project Instructions & Add-Ons', style: AppTypography.titleLarge()),
        const SizedBox(height: 16),
        TextField(
          controller: _briefController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Project Brief',
            hintText: 'Describe your vision, target audience, style preferences...',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _instructionsController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Specific Editing Instructions',
            hintText: 'e.g. Fast cuts, subtitles, specific music style...',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _referenceLinkController,
          decoration: const InputDecoration(
            labelText: 'Reference Link (YouTube, Instagram, Drive)',
            hintText: 'https://...',
            prefixIcon: Icon(Icons.link),
          ),
        ),
        const SizedBox(height: 24),
        Text('Optional Add-Ons', style: AppTypography.titleMedium()),
        const SizedBox(height: 10),
        Column(
          children: MockData.addons.map((addon) {
            final isAdded = _selectedAddons.any((a) => a.id == addon.id);
            return CheckboxListTile(
              value: isAdded,
              activeColor: AppColors.primaryOrange,
              title: Text(addon.name, style: AppTypography.labelLarge(color: AppColors.textDark)),
              subtitle: Text('${addon.description} (+${CurrencyFormatter.format(addon.price)})', style: AppTypography.bodySmall()),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedAddons.add(addon);
                  } else {
                    _selectedAddons.removeWhere((a) => a.id == addon.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 4: Summary & Price breakdown
  Widget _buildStep4Summary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Booking Summary', style: AppTypography.titleLarge()),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(_selectedEditor.avatarUrl)),
                  const SizedBox(width: 10),
                  Text(_selectedEditor.name, style: AppTypography.titleMedium()),
                ],
              ),
              const Divider(height: 24),
              _buildPriceRow(_selectedService.name, _selectedService.defaultBasePrice),
              for (var a in _selectedAddons) _buildPriceRow(a.name, a.price),
              _buildPriceRow('Platform Fee', 0),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: AppTypography.titleLarge()),
                  Text(CurrencyFormatter.format(_totalPrice), style: AppTypography.headlineLarge(color: AppColors.primaryOrange)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, num amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium(color: AppColors.textSecondary)),
          Text(CurrencyFormatter.format(amount), style: AppTypography.labelLarge(color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border(top: BorderSide(color: AppColors.lightBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.format(_totalPrice),
                  style: AppTypography.headlineLarge(color: AppColors.primaryOrange),
                ),
                Text(
                  'Estimated Total',
                  style: AppTypography.bodySmall(color: AppColors.mutedGray),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_currentStep < 4) {
                  setState(() => _currentStep++);
                } else {
                  widget.onProceedToCheckout?.call({
                    'editor': _selectedEditor,
                    'service': _selectedService,
                    'addons': _selectedAddons,
                    'total': _totalPrice,
                    'brief': _briefController.text,
                    'files': _uploadedFiles,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: Row(
                children: [
                  Text(
                    _currentStep == 4 ? 'Proceed to Payment' : 'Continue',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
