import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Admin driver management for Prime Rides.
///
/// Add this file at: lib/prime/screens/drivers.dart
/// Requires: supabase_flutter and image_picker.
class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final _supabase = Supabase.instance.client;
  final _search = TextEditingController();
  late Future<List<Map<String, dynamic>>> _driversFuture;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _driversFuture = _loadDrivers();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadDrivers() async {
    final response = await _supabase
        .from('drivers')
        .select(
          'id, full_name, phone, email, age, status, is_online, '
          'profile_photo_path, created_at',
        )
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _refresh() async {
    final next = _loadDrivers();
    setState(() => _driversFuture = next);
    await next;
  }

  Future<String> _photoUrl(String path) {
    return _supabase.storage.from('driver-documents').createSignedUrl(
      path,
      60 * 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navy = const Color(0xFF173D68);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddDriverScreen()),
          );
          if (created == true) _refresh();
        },
        backgroundColor: navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add driver'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search name or mobile number',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: const Color(0xFFF1F3F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                _FilterChip(
                  label: 'Pending',
                  selected: _filter == 'pending',
                  onTap: () => setState(() => _filter = 'pending'),
                ),
                _FilterChip(
                  label: 'Approved',
                  selected: _filter == 'approved',
                  onTap: () => setState(() => _filter = 'approved'),
                ),
                _FilterChip(
                  label: 'Suspended',
                  selected: _filter == 'suspended',
                  onTap: () => setState(() => _filter = 'suspended'),
                ),
                _FilterChip(
                  label: 'Rejected',
                  selected: _filter == 'rejected',
                  onTap: () => setState(() => _filter = 'rejected'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _driversFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _ErrorState(
                    message: 'Could not load drivers.\n${snapshot.error}',
                    onRetry: _refresh,
                  );
                }

                final query = _search.text.trim().toLowerCase();
                final rows = (snapshot.data ?? []).where((driver) {
                  final status = (driver['status'] ?? 'pending').toString();
                  final name = (driver['full_name'] ?? '').toString().toLowerCase();
                  final phone = (driver['phone'] ?? '').toString().toLowerCase();
                  final matchesFilter = _filter == 'all' || status == _filter;
                  final matchesSearch =
                      query.isEmpty || name.contains(query) || phone.contains(query);
                  return matchesFilter && matchesSearch;
                }).toList();

                if (rows.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 110),
                        Icon(Icons.people_outline_rounded,
                            size: 58, color: Color(0xFF9AA4B2)),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'No drivers found',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Center(
                          child: Text(
                            'Add a driver to see them here.',
                            style: TextStyle(color: Color(0xFF7B8794)),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // WhatsApp-style compact conversation/contact list.
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 86,
                      endIndent: 14,
                    ),
                    itemBuilder: (context, index) {
                      final driver = rows[index];
                      final name = (driver['full_name'] ?? 'Unnamed driver').toString();
                      final phone = (driver['phone'] ?? '').toString();
                      final status = (driver['status'] ?? 'pending').toString();
                      final photoPath =
                          (driver['profile_photo_path'] ?? '').toString();

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        leading: _DriverAvatar(
                          name: name,
                          imageUrl: photoPath.isEmpty ? null : _photoUrl(photoPath),
                        ),
                        title: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            phone,
                            style: const TextStyle(
                              color: Color(0xFF687482),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusLabel(status: status),
                            const SizedBox(height: 5),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 19,
                              color: Color(0xFF9AA4B2),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DriverProfileScreen(
                                driverId: driver['id'].toString(),
                              ),
                            ),
                          );
                          _refresh();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _age = TextEditingController();
  final _aadhaar = TextEditingController();
  final _license = TextEditingController();

  XFile? _profilePhoto;
  XFile? _licenseImage;
  XFile? _aadhaarImage;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _age.dispose();
    _aadhaar.dispose();
    _license.dispose();
    super.dispose();
  }

  Future<XFile?> _pickImage({required bool camera}) async {
    try {
      return await _picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 82,
        maxWidth: 1800,
      );
    } catch (e) {
      _message('Unable to select image: $e');
      return null;
    }
  }

  Future<void> _chooseImage(String kind) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1800,
    );
    if (image == null || !mounted) return;
    setState(() {
      if (kind == 'profile') _profilePhoto = image;
      if (kind == 'license') _licenseImage = image;
      if (kind == 'aadhaar') _aadhaarImage = image;
    });
  }

  String _extension(XFile file) {
    final name = file.name.toLowerCase();
    if (name.endsWith('.png')) return 'png';
    if (name.endsWith('.webp')) return 'webp';
    return 'jpg';
  }

  Future<String> _uploadDriverImage({
    required String driverId,
    required XFile file,
    required String folder,
  }) async {
    final ext = _extension(file);
    final path = '$driverId/$folder/${DateTime.now().microsecondsSinceEpoch}.$ext';
    final Uint8List bytes = await file.readAsBytes();
    final contentType = ext == 'png'
        ? 'image/png'
        : ext == 'webp'
            ? 'image/webp'
            : 'image/jpeg';

    await _supabase.storage.from('driver-documents').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: false,
          ),
        );
    return path;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_licenseImage == null || _aadhaarImage == null) {
      _message('Please upload both Driving Licence and Aadhaar images.');
      return;
    }

    setState(() => _saving = true);
    String? createdDriverId;

    try {
      // Admin creates the driver record. A Supabase Auth user is NOT created
      // here; user_id remains null until a separate driver account is linked.
      final inserted = await _supabase.from('drivers').insert({
        'full_name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'email': _email.text.trim(),
        'age': int.parse(_age.text.trim()),
        'aadhaar_no': _aadhaar.text.trim(),
        'license_no': _license.text.trim().toUpperCase(),
        'status': 'pending',
        'is_online': false,
      }).select('id').single();

      createdDriverId = inserted['id'].toString();

      final uploads = <Map<String, dynamic>>[];

      if (_profilePhoto != null) {
        final path = await _uploadDriverImage(
          driverId: createdDriverId,
          file: _profilePhoto!,
          folder: 'profile',
        );
        await _supabase
            .from('drivers')
            .update({'profile_photo_path': path})
            .eq('id', createdDriverId);
      }

      final licencePath = await _uploadDriverImage(
        driverId: createdDriverId,
        file: _licenseImage!,
        folder: 'licence',
      );
      uploads.add({
        'driver_id': createdDriverId,
        'doc_type': 'driving_licence',
        'file_path': licencePath,
        'status': 'pending',
      });

      final aadhaarPath = await _uploadDriverImage(
        driverId: createdDriverId,
        file: _aadhaarImage!,
        folder: 'aadhaar',
      );
      uploads.add({
        'driver_id': createdDriverId,
        'doc_type': 'identity',
        'file_path': aadhaarPath,
        'status': 'pending',
      });

      await _supabase.from('driver_documents').insert(uploads);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Driver added successfully.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final idNote = createdDriverId == null
          ? ''
          : '\nDriver record was created (ID: $createdDriverId), but one of the uploads/saves failed. Open Drivers and check this record before retrying.';
      _message('Could not finish adding driver: $e$idNote');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String? _required(String? value, String label) {
    if ((value ?? '').trim().isEmpty) return '$label is required';
    return null;
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLength,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLength: maxLength,
      validator: validator,
      textCapitalization: label == 'Full name'
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        counterText: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF173D68);
    return Scaffold(
      appBar: AppBar(title: const Text('Add driver')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
          children: [
            const _SectionHeading(
              title: 'Personal information',
              subtitle: 'Enter the driver’s basic contact details.',
            ),
            const SizedBox(height: 14),
            _field(
              controller: _name,
              label: 'Full name',
              icon: Icons.person_outline_rounded,
              validator: (v) {
                final error = _required(v, 'Full name');
                if (error != null) return error;
                return v!.trim().length < 2 ? 'Enter a valid name' : null;
              },
            ),
            const SizedBox(height: 13),
            _field(
              controller: _phone,
              label: 'Contact number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Contact number is required';
                if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                  return 'Enter a valid 10-digit Indian mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _field(
              controller: _email,
              label: 'Email address (optional)',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return null;
                return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                    ? null
                    : 'Enter a valid email address';
              },
            ),
            const SizedBox(height: 13),
            _field(
              controller: _age,
              label: 'Age (18 or above)',
              icon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
              maxLength: 3,
              validator: (v) {
                final age = int.tryParse((v ?? '').trim());
                if (age == null) return 'Enter the driver’s age';
                if (age < 18 || age > 100) return 'Driver must be at least 18';
                return null;
              },
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              title: 'Profile photo',
              subtitle: 'Optional photo shown in the driver list.',
            ),
            const SizedBox(height: 12),
            _ImagePickerTile(
              title: 'Driver profile photo',
              subtitle: 'JPG, PNG or WebP',
              file: _profilePhoto,
              requiredField: false,
              onTap: () => _chooseImage('profile'),
              onRemove: () => setState(() => _profilePhoto = null),
              circle: true,
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              title: 'Identity & driving documents',
              subtitle: 'Both document images are required for registration.',
            ),
            const SizedBox(height: 14),
            _field(
              controller: _aadhaar,
              label: 'Aadhaar ID number',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
              maxLength: 12,
              validator: (v) {
                final value = (v ?? '').replaceAll(' ', '');
                if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
                  return 'Enter a valid 12-digit Aadhaar number';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _ImagePickerTile(
              title: 'Upload Aadhaar ID',
              subtitle: 'Required • Select a clear image',
              file: _aadhaarImage,
              requiredField: true,
              onTap: () => _chooseImage('aadhaar'),
              onRemove: () => setState(() => _aadhaarImage = null),
            ),
            const SizedBox(height: 18),
            _field(
              controller: _license,
              label: 'Driving licence number',
              icon: Icons.credit_card_outlined,
              validator: (v) {
                final error = _required(v, 'Driving licence number');
                if (error != null) return error;
                return v!.trim().length < 5
                    ? 'Enter a valid driving licence number'
                    : null;
              },
            ),
            const SizedBox(height: 13),
            _ImagePickerTile(
              title: 'Upload Driving Licence',
              subtitle: 'Required • Select a clear image',
              file: _licenseImage,
              requiredField: true,
              onTap: () => _chooseImage('license'),
              onRemove: () => setState(() => _licenseImage = null),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFFFE1A6)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF9A6500)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'New drivers are saved with Pending status. Review the documents and approve the driver separately. This form does not create a driver login account.',
                      style: TextStyle(
                        color: Color(0xFF75500B),
                        height: 1.4,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.person_add_alt_1_rounded),
                label: Text(_saving ? 'Saving driver...' : 'Save driver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key, required this.driverId});
  final String driverId;

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final _supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    return await _supabase
        .from('drivers')
        .select('*, driver_documents(*)')
        .eq('id', widget.driverId)
        .single();
  }

  Future<String?> _signedUrl(String? path) async {
    if (path == null || path.isEmpty) return null;
    return _supabase.storage.from('driver-documents').createSignedUrl(
      path,
      60 * 30,
    );
  }

  Future<void> _setStatus(String status) async {
    try {
      await _supabase
          .from('drivers')
          .update({'status': status})
          .eq('id', widget.driverId);
      if (!mounted) return;
      setState(() => _future = _load());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Driver status updated to $status')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver profile')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return _ErrorState(
              message: 'Could not load driver profile.\n${snapshot.error ?? ''}',
              onRetry: () => setState(() => _future = _load()),
            );
          }

          final driver = snapshot.data!;
          final docs = List<Map<String, dynamic>>.from(
            driver['driver_documents'] ?? const [],
          );
          final status = (driver['status'] ?? 'pending').toString();
          final photoPath = driver['profile_photo_path']?.toString();

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF173D68),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    FutureBuilder<String?>(
                      future: _signedUrl(photoPath),
                      builder: (context, photo) => CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            photo.data == null ? null : NetworkImage(photo.data!),
                        child: photo.data == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 48,
                                color: Color(0xFF173D68),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      driver['full_name']?.toString() ?? 'Driver',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      driver['phone']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    _StatusLabel(status: status, light: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _SectionHeading(title: 'Personal details'),
              const SizedBox(height: 8),
              _DetailCard(items: [
                _DetailItem('Full name', driver['full_name']),
                _DetailItem('Contact number', driver['phone']),
                _DetailItem('Email address', _empty(driver['email'])),
                _DetailItem('Age', driver['age']?.toString()),
                _DetailItem('Aadhaar ID number', _maskAadhaar(driver['aadhaar_no'])),
                _DetailItem('Driving licence number', driver['license_no']),
                _DetailItem('Driver ID', driver['id']),
                _DetailItem(
                  'Login account linked',
                  driver['user_id'] == null ? 'No' : 'Yes',
                ),
              ]),
              const SizedBox(height: 18),
              const _SectionHeading(title: 'Driver activity'),
              const SizedBox(height: 8),
              _DetailCard(items: [
                _DetailItem(
                  'Availability',
                  driver['is_online'] == true ? 'Online' : 'Offline',
                ),
                _DetailItem('Total trips', driver['total_trips']?.toString()),
                _DetailItem('Rating', driver['rating']?.toString()),
                _DetailItem('Created on', _date(driver['created_at'])),
                _DetailItem('Assigned vehicle ID', _empty(driver['vehicle_id'])),
              ]),
              const SizedBox(height: 18),
              const _SectionHeading(title: 'Uploaded documents'),
              const SizedBox(height: 8),
              if (docs.isEmpty)
                const _EmptyDocumentCard()
              else
                ...docs.map((doc) => _DocumentTile(
                      title: doc['doc_type'] == 'driving_licence'
                          ? 'Driving Licence'
                          : doc['doc_type'] == 'identity'
                              ? 'Aadhaar ID'
                              : 'Other document',
                      path: doc['file_path']?.toString() ?? '',
                      status: doc['status']?.toString() ?? 'pending',
                      signedUrl: _signedUrl,
                    )),
              const SizedBox(height: 22),
              const _SectionHeading(title: 'Manage driver'),
              const SizedBox(height: 10),
              if (status != 'approved')
                SizedBox(
                  height: 49,
                  child: ElevatedButton.icon(
                    onPressed: () => _setStatus('approved'),
                    icon: const Icon(Icons.verified_rounded),
                    label: const Text('Approve driver'),
                  ),
                ),
              if (status != 'rejected') ...[
                const SizedBox(height: 9),
                OutlinedButton.icon(
                  onPressed: () => _setStatus('rejected'),
                  icon: const Icon(Icons.block_rounded),
                  label: const Text('Reject driver'),
                ),
              ],
              if (status != 'suspended') ...[
                const SizedBox(height: 9),
                OutlinedButton.icon(
                  onPressed: () => _setStatus('suspended'),
                  icon: const Icon(Icons.pause_circle_outline_rounded),
                  label: const Text('Suspend driver'),
                ),
              ],
              if (status != 'pending') ...[
                const SizedBox(height: 9),
                TextButton(
                  onPressed: () => _setStatus('pending'),
                  child: const Text('Move back to pending'),
                ),
              ],
              const SizedBox(height: 8),
              const Text(
                'Approving a driver changes the driver record status only. It does not create or link a Supabase Auth login.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF7B8794), fontSize: 11),
              ),
            ],
          );
        },
      ),
    );
  }

  String _empty(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? 'Not provided' : text;
  }

  String _maskAadhaar(dynamic value) {
    final text = value?.toString() ?? '';
    if (text.length != 12) return 'Not provided';
    return 'XXXX XXXX ${text.substring(8)}';
  }

  String _date(dynamic value) {
    if (value == null) return 'Not available';
    final date = DateTime.tryParse(value.toString())?.toLocal();
    if (date == null) return value.toString();
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.path,
    required this.status,
    required this.signedUrl,
  });

  final String title;
  final String path;
  final String status;
  final Future<String?> Function(String?) signedUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE7EBF0)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF0FF),
          child: Icon(Icons.description_outlined, color: Color(0xFF173D68)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('Verification: $status'),
        trailing: const Icon(Icons.open_in_new_rounded, size: 19),
        onTap: () async {
          final url = await signedUrl(path);
          if (url == null || !context.mounted) return;
          await showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                    InteractiveViewer(
                      child: Image.network(
                        url,
                        errorBuilder: (_, __, ___) => const Padding(
                          padding: EdgeInsets.all(30),
                          child: Text('Could not preview this document.'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.name, required this.imageUrl});
  final String name;
  final Future<String>? imageUrl;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: imageUrl,
      builder: (context, snapshot) {
        final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
        return CircleAvatar(
          radius: 27,
          backgroundColor: const Color(0xFFEAF0FF),
          backgroundImage:
              snapshot.data == null ? null : NetworkImage(snapshot.data!),
          child: snapshot.data == null
              ? Text(
                  initial,
                  style: const TextStyle(
                    color: Color(0xFF173D68),
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: const Color(0xFFDCE8F8),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFF173D68) : const Color(0xFF687482),
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status, this.light = false});
  final String status;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      'approved' => const Color(0xFF16834A),
      'rejected' => const Color(0xFFC43D45),
      'suspended' => const Color(0xFF9A6500),
      _ => const Color(0xFF687482),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: .16) : color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: light ? Colors.white : color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: .4,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF173D68),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(color: Color(0xFF7B8794), fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _ImagePickerTile extends StatelessWidget {
  const _ImagePickerTile({
    required this.title,
    required this.subtitle,
    required this.file,
    required this.requiredField,
    required this.onTap,
    required this.onRemove,
    this.circle = false,
  });

  final String title;
  final String subtitle;
  final XFile? file;
  final bool requiredField;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          border: Border.all(
            color: file == null ? const Color(0xFFDCE2E9) : const Color(0xFF9BB7DD),
          ),
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFFAFBFC),
        ),
        child: Row(
          children: [
            if (circle && file != null)
              FutureBuilder<Uint8List>(
                future: file!.readAsBytes(),
                builder: (context, snapshot) => CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      snapshot.hasData ? MemoryImage(snapshot.data!) : null,
                  child: snapshot.hasData ? null : const Icon(Icons.person),
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  file == null
                      ? Icons.add_a_photo_outlined
                      : Icons.check_circle_rounded,
                  color: const Color(0xFF173D68),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    file?.name ?? subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7B8794),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (file != null)
              IconButton(
                tooltip: 'Remove image',
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, color: Color(0xFFC43D45)),
              )
            else
              Icon(
                requiredField ? Icons.upload_file_rounded : Icons.chevron_right,
                color: const Color(0xFF7B8794),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem {
  _DetailItem(this.label, dynamic value)
      : value = value == null || value.toString().trim().isEmpty
            ? 'Not provided'
            : value.toString();

  final String label;
  final String value;
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.items});
  final List<_DetailItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      items[i].label,
                      style: const TextStyle(
                        color: Color(0xFF7B8794),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Text(
                      items[i].value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF25364A),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1)
              const Divider(height: 1, color: Color(0xFFF0F2F5)),
          ],
        ],
      ),
    );
  }
}

class _EmptyDocumentCard extends StatelessWidget {
  const _EmptyDocumentCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Text(
          'No documents uploaded for this driver.',
          style: TextStyle(color: Color(0xFF7B8794)),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 44, color: Color(0xFFC43D45)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
