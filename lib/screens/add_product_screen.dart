import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/modules/product.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/widgets/drawer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProductScreen extends StatefulWidget {
  static final route = '/add_product_screen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _id = '';
  String _title = '';
  String _description = '';
  String _price = '';
  String _imageUrl = '';
  bool _isImageUrL = false;
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _titleFocusNode = FocusNode();

  bool _isEdit = false;

  File _image = File('hello');
  ImagePicker _imagePicker = ImagePicker();

  _pickImage(ImageSource imageSource) async {
    final image = await _imagePicker.pickImage(source: imageSource, imageQuality: 50);
    var imageKey = UniqueKey();
    setState(() {
      _image = File(image!.path);
    });
    try {
      await FirebaseStorage.instance
          .ref('realShop/assets/images/$imageKey.jpg/')
          .putFile(_image);
      _imageUrl = await FirebaseStorage.instance
          .ref('realShop/assets/images/$imageKey.jpg')
          .getDownloadURL();
    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('An Error Occurred !'),
                content: Text('try pick an image later'),
              ));
    }
  }

  _submit() {
    _isLoading = true;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }else{
      _isLoading = false ;
      return;
    }
    if ((_imageUrl == '') &&
        (!_imageUrl.startsWith('http') || !_imageUrl.startsWith('https')) &&
        (!_imageUrl.endsWith('jpg') ||
            !_imageUrl.endsWith('png') ||
            !_imageUrl.endsWith('jpeg'))) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text('please Enter a valid imageURL'),
              ));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _isEdit
        ? Provider.of<ProductsProvider>(context, listen: false).updateProduct(
            _id,
            Product(
              title: _title,
              description: _description,
              price: double.parse(_price),
              imageUrl: _imageUrl,
            ))
        : Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(Product(
            title: _title,
            description: _description,
            price: double.parse(_price),
            imageUrl: _imageUrl,
          ));
    setState(() {
      _title = '';
      _description = '';
      _price = '';
      _imageUrl = '';
      _isLoading = false;
      _isImageUrL = false;
      _isEdit = false;
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Product Added Successfully'),
            ));
    _formKey.currentState!.reset();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      _id = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        _isEdit = true;
      });
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Product editingProduct =
            Provider.of<ProductsProvider>(context, listen: false)
                .getOneProduct(_id);
        setState(() {
          _title = editingProduct.title;
          _description = editingProduct.description;
          _price = editingProduct.price.toString();
          _imageUrl = editingProduct.imageUrl;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _id = '';
    _title = '';
    _description = '';
    _price = '';
    _imageUrl = '';
    _isImageUrL = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('$_id' == '' ? 'Add Product' : 'UpdateProduct'),
    );
    return Scaffold(
      appBar: appBar,
      drawer: DrawerWidget(),
      body:  Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  appBar.preferredSize.height),
          margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('title'),
                    initialValue: _title,
                    textInputAction: TextInputAction.next,
                    focusNode: _titleFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      suffixText: _title,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _title = value;
                    },
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field can not be empty';
                      }
                    },
                    onSaved: (value) {
                      _title = value ?? '';
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    key: ValueKey('price'),
                    initialValue: _price,
                    focusNode: _priceFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      suffixText: _price,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please determine a price for this product';
                      }
                      if (double.tryParse(value) == null) {
                        return 'please enter a valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'please enter a valid number';
                      }
                    },
                    onSaved: (value) {
                      _price = value ?? '';
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    key: ValueKey('description'),
                    initialValue: _description,
                    focusNode: _descriptionFocusNode,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 200,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      helperText: _description,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onSaved: (value) {
                      _description = value ?? '';
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.yellow,
                        activeTrackColor: Colors.green.shade900,
                        onChanged: (value) {
                          setState(() {
                            _isImageUrL = !_isImageUrL;
                          });
                        },
                        value: _isImageUrL,
                      ),
                      Text(
                        'NetWork Image',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (_isImageUrL)
                    TextFormField(
                      key: ValueKey('Image Url'),
                      minLines: 1,
                      initialValue: _imageUrl,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        labelText: 'ImageUrl',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please write image URL';
                        }
                      },
                      onSaved: (value) {
                        _imageUrl = value ?? '';
                      },
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton.icon(
                          textColor: Colors.purple.shade900,
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                          },
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                          ),
                          label: Text('Camera'),
                        ),
                        FlatButton.icon(
                          textColor: Colors.purple.shade900,
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                          icon: Icon(
                            Icons.image,
                            size: 30,
                          ),
                          label: Text('Gallery'),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          color: Colors.pink,
                          onPressed: _submit,
                          child: Text(
                            'Submit Product',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
