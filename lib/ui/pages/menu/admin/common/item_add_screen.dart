import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class ItemAddScreen extends StatefulWidget {
  final String type;
  final dynamic item;
  const ItemAddScreen({super.key, this.type = '', this.item});

  @override
  State<ItemAddScreen> createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  static final List<String> enumRatings = ['1.0', '2.0', '3.0', '4.0', '5.0'];

  static final List<String> enumCuisine = [
    'Italian',
    'Chinese',
    'Indian',
    'Thai',
    'French',
    'Japanese',
    'Mexican',
    'Western',
    'Malay',
    'Cantonese',
    'Spanish',
    'Portuguese',
    'Greek',
  ];

  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();
  final TextEditingController _field5Controller = TextEditingController();
  String txtRating = enumRatings[enumRatings.length - 1];
  String txtCuisine = enumCuisine[0];

  XFile? facilityImage;
  XFile? coverImage;
  XFile? galleryPhoto1;
  XFile? galleryPhoto2;
  XFile? galleryPhoto3;

  String urlFacility = "";
  String urlCover = "";
  String urlGallery1 = "";
  String urlGallery2 = "";
  String urlGallery3 = "";

  bool isNew = false;
  late dynamic item;

  @override
  void initState() {
    super.initState();
    isNew = widget.item == null;

    if (isNew == false) {
      item = widget.item;

      urlCover = item.imageUrl.toString();

      urlGallery1 = item.gallery[0].toString();
      urlGallery2 = item.gallery[1].toString();
      urlGallery3 = item.gallery[2].toString();

      txtRating = item.rating.toString();

      if (item is HotelModel) {
        HotelModel model = item as HotelModel;

        _field1Controller.text = model.name.toString();
        _field2Controller.text = model.address.toString();
        _field3Controller.text = model.price.toString();
        _field4Controller.text = model.about.toString();

        urlFacility = model.imageFacility.toString();
      } else if (item is RestaurantModel) {
        RestaurantModel model = item as RestaurantModel;

        _field1Controller.text = model.name.toString();
        _field2Controller.text = model.address.toString();
        _field3Controller.text = model.price.toString();
        _field4Controller.text = model.about.toString();

        txtCuisine = model.cuisine.toString();
      } else if (item is CarModel) {
        CarModel model = item as CarModel;

        _field1Controller.text = model.name.toString();
        _field2Controller.text = model.plate.toString();
        _field3Controller.text = model.seat.toString();
        _field4Controller.text = model.price.toString();
        _field5Controller.text = model.address.toString();
      }
    }
  }

  Future<void> _pickImage(String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (type == "facility") {
          facilityImage = image;
        } else if (type == "cover") {
          coverImage = image;
        } else if (type == "gallery") {
          galleryPhoto1 = image;
        } else if (type == "gallery2") {
          galleryPhoto2 = image;
        } else if (type == "gallery3") {
          galleryPhoto3 = image;
        }
      });
    }
  }

  void _save() async {
    String field1 = _field1Controller.text.trim();
    String field2 = _field2Controller.text.trim();
    String field3 = _field3Controller.text.trim();
    String field4 = _field4Controller.text.trim();
    String field5 = _field5Controller.text.trim();

    bool isInvalid = !validation();

    /*if (widget.type == "hotels") {
      isMissOut = isRequiredFieldEmpty() || facilityImage == null;
    } else if (widget.type == "restaurants") {
      isMissOut = isRequiredFieldEmpty() || isImageEmpty();
    } else if (widget.type == "cars") {
      isMissOut = isRequiredFieldEmpty() || field5.isEmpty;
    }*/

    if (isInvalid) {
      showMessageDialog(
        title: "Opps",
        message: "All field are required.",
        context: context,
      );
      return;
    }

    bool isSuccess = false;
    var uuid = Uuid();
    String uid = isNew ? uuid.v1() : item.uid.toString();
    showLoadingDialog(context, "Saving in progress...");
    try {
      if (widget.type == "hotels") {
        urlFacility =
            facilityImage == null
                ? urlFacility
                : await HotelRepository.uploadPhoto(
                  xFile: facilityImage!,
                  filename: '$uid-facility',
                );

        urlCover = facilityImage == null ? urlCover : await HotelRepository.uploadPhoto(
          xFile: coverImage!,
          filename: '$uid-cover',
        );

        urlGallery1 = galleryPhoto1 == null ? urlGallery1 : await HotelRepository.uploadPhoto(
          xFile: galleryPhoto1!,
          filename: '$uid-gallery1',
        );

        urlGallery2 = galleryPhoto2 == null ? urlGallery2 : await HotelRepository.uploadPhoto(
          xFile: galleryPhoto2!,
          filename: '$uid-gallery2',
        );

        urlGallery3 = galleryPhoto3 == null ? urlGallery3 : await HotelRepository.uploadPhoto(
          xFile: galleryPhoto3!,
          filename: '$uid-gallery3',
        );

        HotelModel model = HotelModel(
          name: field1,
          address: field2,
          price: double.parse(field3),
          rating: double.parse(txtRating),
          about: field4,
          imageFacility: urlFacility,
          imageUrl: urlCover,
          gallery: [urlGallery1, urlGallery2, urlGallery3],
          uid: uid,
        );

        isSuccess = await HotelRepository.post(data: model);
      } else if (widget.type == "restaurants") {
        urlCover = coverImage == null ? urlCover : await RestaurantRepository.uploadPhoto(
          xFile: coverImage!,
          filename: '$uid-cover',
        );
        urlGallery1 = galleryPhoto1 == null ? urlGallery1 : await RestaurantRepository.uploadPhoto(
          xFile: galleryPhoto1!,
          filename: '$uid-gallery1',
        );
        urlGallery2 = galleryPhoto2 == null ? urlGallery2 : await RestaurantRepository.uploadPhoto(
          xFile: galleryPhoto2!,
          filename: '$uid-gallery2',
        );
        urlGallery3 = galleryPhoto3 == null ? urlGallery3 : await RestaurantRepository.uploadPhoto(
          xFile: galleryPhoto3!,
          filename: '$uid-gallery3',
        );

        RestaurantModel model = RestaurantModel(
          uid: uid,
          name: field1,
          address: field2,
          price: double.parse(field3),
          rating: double.parse(txtRating),
          imageUrl: urlCover,
          gallery: [urlGallery1, urlGallery2, urlGallery3],
          about: field4,
          cuisine: txtCuisine,
        );

        isSuccess = await RestaurantRepository.post(data: model);
      } else if (widget.type == "cars") {
        urlCover = coverImage == null ? urlCover : await CarRepository.uploadPhoto(
          xFile: coverImage!,
          filename: '$uid-cover',
        );
        urlGallery1 = galleryPhoto1 == null ? urlGallery1 : await CarRepository.uploadPhoto(
          xFile: galleryPhoto1!,
          filename: '$uid-gallery1',
        );
        urlGallery2 = galleryPhoto2 == null ? urlGallery2 : await CarRepository.uploadPhoto(
          xFile: galleryPhoto2!,
          filename: '$uid-gallery2',
        );
        urlGallery3 = galleryPhoto3 == null ? urlGallery3 : await CarRepository.uploadPhoto(
          xFile: galleryPhoto3!,
          filename: '$uid-gallery3',
        );

        CarModel model = CarModel(
          uid: uid,
          name: field1,
          plate: field2,
          seat: double.parse(field3),
          price: double.parse(field4),
          address: field5,

          rating: double.parse(txtRating),
          imageUrl: urlCover,
          gallery: [urlGallery1, urlGallery2, urlGallery3],
        );

        isSuccess = await CarRepository.post(data: model);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      return;
    }

    if (isSuccess) {
      showToast("Post successfully");
      context.pop(true);
    }
  }

  bool validation() {
    String field1 = _field1Controller.text.trim();
    String field2 = _field2Controller.text.trim();
    String field3 = _field3Controller.text.trim();
    String field4 = _field4Controller.text.trim();
    String field5 = _field5Controller.text.trim();
    bool isDefaultFieldsMissOut = field1.isEmpty || field2.isEmpty || field3.isEmpty || field4.isEmpty;

    if (isDefaultFieldsMissOut || (widget.type == "cars" && field5.isEmpty)) {
      return false;
    }

    // if is not new, the photo ady exist not need to check
    if (isNew == false){
      return true;
    }

    // following check for new fill up which dedicated for photo
    if (isImageEmpty()) {
      return false;
    }
    if (widget.type == "cars" && facilityImage == null) {
      return false;
    }

    return true;
  }

  bool isRequiredFieldEmpty() {
    String field1 = _field1Controller.text.trim();
    String field2 = _field2Controller.text.trim();
    String field3 = _field3Controller.text.trim();
    String field4 = _field4Controller.text.trim();
    return field1.isEmpty || field2.isEmpty || field3.isEmpty || field4.isEmpty;
  }

  bool isImageEmpty() {
    return coverImage == null ||
        galleryPhoto1 == null ||
        galleryPhoto2 == null ||
        galleryPhoto3 == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "${isNew ? "Add" : "Edit"} ${widget.type.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 10),
            ..._getFields(),
            if (widget.type == "hotels")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Facilities :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  uploadButton(
                    "facility",
                    facilityImage == null
                        ? urlFacility
                        : _getImageName(facilityImage),
                  ),
                ],
              ),

            // Cover Photo
            const SizedBox(height: 10),
            const Text(
              "Cover Photo :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            uploadButton(
              "cover",
              coverImage == null ? urlCover : _getImageName(coverImage),
            ),

            // Gallery
            const SizedBox(height: 10),
            const Text(
              "Gallery :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            uploadButton(
              "gallery",
              galleryPhoto1 == null
                  ? urlGallery1
                  : _getImageName(galleryPhoto1),
            ),
            uploadButton(
              "gallery2",
              galleryPhoto2 == null
                  ? urlGallery2
                  : _getImageName(galleryPhoto2),
            ),
            uploadButton(
              "gallery3",
              galleryPhoto3 == null
                  ? urlGallery3
                  : _getImageName(galleryPhoto3),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _save(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Save", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create text fields
  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isAmount = false,
    bool isInteger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getFieldLabel(label),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          inputFormatters:
              isAmount || isInteger
                  ? [FixedDecimalInputFormatter(allowDecimal: isAmount)]
                  : [],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String getFieldLabel(String label) {
    if (widget.type == "hotels") {
      if (label == "field1") {
        return "Hotel Name";
      } else if (label == "field2") {
        return "Address";
      } else if (label == "field3") {
        return "Price/night";
      } else if (label == "field4") {
        return "Abouts";
      }
    } else if (widget.type == "restaurants") {
      if (label == "field1") {
        return "Restaurant Name";
      } else if (label == "field2") {
        return "Address";
      } else if (label == "field3") {
        return "Price/Pax";
      } else if (label == "field4") {
        return "Abouts";
      }
    } else if (widget.type == "cars") {
      if (label == "field1") {
        return "Car Type";
      } else if (label == "field2") {
        return "Car Plate";
      } else if (label == "field3") {
        return "Num of seats";
      } else if (label == "field4") {
        return "Rental/day";
      } else if (label == "field5") {
        return "Pick Up Point";
      } else if (label == "field6") {
        return "Pick Up Time";
      }
    }
    return "";
  }

  Widget uploadButton(String type, String? imageName) {
    return Row(
      children: [
        if (type.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.upload, size: 30, color: Colors.black),
            onPressed: () => _pickImage(type),
          ),
        if (imageName != null)
          Expanded(
            child: Text(
              imageName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }

  String _getImageName(XFile? file) {
    if (file == null) {
      return "";
    }
    return file.name;
  }

  List<Widget> _getFields() {
    if (widget.type == "hotels") {
      return [
        buildTextField("field1", _field1Controller),
        buildTextField("field2", _field2Controller),
        buildTextField("field3", _field3Controller, isAmount: true),
        _getRatingField(),
        buildTextField("field4", _field4Controller),
      ];
    } else if (widget.type == "restaurants") {
      return [
        buildTextField("field1", _field1Controller),
        buildTextField("field2", _field2Controller),
        buildTextField("field3", _field3Controller, isInteger: true),
        _getRatingField(),
        buildTextField("field4", _field4Controller),
        _getCuisineField(),
      ];
    } else if (widget.type == "cars") {
      return [
        buildTextField("field1", _field1Controller),
        buildTextField("field2", _field2Controller),
        buildTextField("field3", _field3Controller, isInteger: true),
        buildTextField("field4", _field4Controller, isAmount: true),
        buildTextField("field5", _field5Controller),
        _getRatingField(),
      ];
    }
    return [];
  }

  Widget _getRatingField() {
    return DropdownSelector(
      label: "Rating",
      value: txtRating,
      items: enumRatings,
      onChanged: (value) => setState(() => txtRating = value!),
    );
  }

  Widget _getCuisineField() {
    return DropdownSelector(
      label: "Cuisine",
      value: txtCuisine,
      items: enumCuisine,
      onChanged: (value) => setState(() => txtCuisine = value!),
    );
  }
}

class FixedDecimalInputFormatter extends TextInputFormatter {
  final bool allowDecimal;

  FixedDecimalInputFormatter({this.allowDecimal = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    final RegExp pattern =
        allowDecimal
            ? RegExp(r'^\d+(\.\d{0,2})?$') // Allow up to 2 decimal places
            : RegExp(r'^\d*$'); // Digits only

    if (pattern.hasMatch(newText) || newText.isEmpty) {
      return newValue; // Allow valid input
    }

    return oldValue; // Reject invalid input (like preventDefault)
  }
}
