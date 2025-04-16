
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/ui/widgets/widgets.dart';

class ItemAddScreen extends StatefulWidget {
  final String type;
  const ItemAddScreen({super.key, this.type = ''});

  @override
  State<ItemAddScreen> createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingsController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  XFile? facilityImage;
  XFile? coverImage;
  XFile? galleryPhoto;

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
          galleryPhoto = image;
        }
      });
    }
  }

  void _save() async {
    if (hotelNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        ratingsController.text.trim().isEmpty ||
        aboutController.text.trim().isEmpty ||
        facilityImage == null ||
        coverImage == null ||
        galleryPhoto == null) {
      showMessageDialog(
        title: "Opps",
        message: "All field are required.",
        context: context,
      );
      return;
    }
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
          "Add ${widget.type.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}",
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

            buildTextField("field1", hotelNameController),
            buildTextField("field2", addressController),
            buildTextField("field3", priceController),
            buildTextField("field4", ratingsController),
            buildTextField("field5", aboutController),

            if (widget.type == "hotel")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Facilities :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  uploadButton("facility", _getImageName(facilityImage)),
                ],
              ),

            // Cover Photo
            const SizedBox(height: 10),
            const Text(
              "Cover Photo :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            uploadButton("cover", _getImageName(coverImage)),

            // Gallery
            const SizedBox(height: 10),
            const Text(
              "Gallery :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            uploadButton("gallery", _getImageName(galleryPhoto)),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
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
  Widget buildTextField(String label, TextEditingController controller) {
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
    if (widget.type == "hotel") {
      if (label == "field1") {
        return "Hotel Name";
      } else if (label == "field2") {
        return "Address";
      } else if (label == "field3") {
        return "Price/night";
      } else if (label == "field4") {
        return "Ratings";
      } else if (label == "field5") {
        return "Abouts";
      }
    } else if (widget.type == "restaurant") {
      if (label == "field1") {
        return "Restaurant Name";
      } else if (label == "field2") {
        return "Address";
      } else if (label == "field3") {
        return "Price/Pax";
      } else if (label == "field4") {
        return "Ratings";
      }
      else if (label == "field5") {
        return "Abouts";
      }
    } else if (widget.type == "transportation") {
      if (label == "field1") {
        return "Car Type";
      } else if (label == "field2") {
        return "Num of seats";
      } else if (label == "field3") {
        return "Rental/day";
      } else if (label == "field4") {
        return "Pick Up Point";
      }
      else if (label == "field5") {
        return "Pick Up Time";
      }
    }
    return "";
  }

  Widget uploadButton(String type, String? imageName) {
    return Row(
      children: [
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
}
