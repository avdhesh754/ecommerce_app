import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../../shared/models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;
  
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _brandController = TextEditingController();
  final _stockController = TextEditingController();
  final _tagsController = TextEditingController();
  
  final ProductController _productController = Get.find<ProductController>();
  
  String? _selectedCategory;
  bool _isActive = true;
  bool _isFeatured = false;
  List<String> _selectedImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final product = widget.product!;
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _originalPriceController.text = product.originalPrice?.toString() ?? '';
    _brandController.text = product.brand ?? '';
    _stockController.text = product.stockQuantity.toString();
    _tagsController.text = product.tags.join(', ');
    _selectedCategory = product.category;
    _isActive = product.isActive;
    _isFeatured = product.isFeatured;
    _selectedImages = List.from(product.images);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _brandController.dispose();
    _stockController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Obx(() => LoadingOverlay(
        isLoading: _productController.isLoading || _isUploading,
        child: _buildForm(),
      )),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Card
            _buildSection(
              title: 'Basic Information',
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  hint: 'Enter product name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter product description',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                CustomTextField(
                  controller: _brandController,
                  label: 'Brand',
                  hint: 'Enter brand name',
                ),
              ],
            ),

            SizedBox(height: 24),

            // Category and Pricing Card
            _buildSection(
              title: 'Category & Pricing',
              children: [
                Obx(() => DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _productController.categories.map((category) =>
                    DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                )),
                SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        label: 'Price',
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.attach_money),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _originalPriceController,
                        label: 'Original Price (Optional)',
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.attach_money),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (double.tryParse(value) == null) {
                              return 'Please enter valid price';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // Inventory Card
            _buildSection(
              title: 'Inventory',
              children: [
                CustomTextField(
                  controller: _stockController,
                  label: 'Stock Quantity',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(Icons.inventory),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter valid quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                CustomTextField(
                  controller: _tagsController,
                  label: 'Tags',
                  hint: 'Enter tags separated by commas',
                  prefixIcon: Icon(Icons.label),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Images Card
            _buildSection(
              title: 'Product Images',
              children: [
                _buildImagePicker(),
              ],
            ),

            SizedBox(height: 24),

            // Settings Card
            _buildSection(
              title: 'Settings',
              children: [
                SwitchListTile(
                  title: Text('Active Product'),
                  subtitle: Text('Product will be visible to customers'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                SwitchListTile(
                  title: Text('Featured Product'),
                  subtitle: Text('Product will appear in featured section'),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),

            SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: widget.product == null ? 'Add Product' : 'Update Product',
                onPressed: _saveProduct,
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.heading4,
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.add_photo_alternate),
              label: Text('Add Images'),
            ),
            SizedBox(width: 16),
            Text(
              '${_selectedImages.length} images selected',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.backgroundColor,
                        ),
                        child: _selectedImages[index].startsWith('http')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _selectedImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      color: AppTheme.textSecondary,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.image,
                                color: AppTheme.textSecondary,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      for (final image in images) {
        final imageUrl = await _productController.uploadImage(image.path);
        if (imageUrl != null) {
          setState(() {
            _selectedImages.add(imageUrl);
          });
        }
      }

      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final productData = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text),
      'originalPrice': _originalPriceController.text.isNotEmpty 
          ? double.parse(_originalPriceController.text)
          : null,
      'category': _selectedCategory,
      'brand': _brandController.text.trim().isNotEmpty 
          ? _brandController.text.trim() 
          : null,
      'stockQuantity': int.parse(_stockController.text),
      'isActive': _isActive,
      'isFeatured': _isFeatured,
      'images': _selectedImages,
      'tags': _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
    };

    bool success;
    if (widget.product == null) {
      success = await _productController.createProduct(productData);
    } else {
      success = await _productController.updateProduct(widget.product!.id, productData);
    }

    if (success) {
      Get.back();
    }
  }
}