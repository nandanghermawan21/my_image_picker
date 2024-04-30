import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/type.dart';

class MultipleImagePickerComponent extends StatelessWidget {
  final MultipleImagePickerController controller;
  final WidgetBuilder? placeHolder;
  final Widget? addIcon;
  final bool camera;
  final bool galery;
  final Alignment? popUpAlign;
  final WidgetFromDataBuilder<List<Widget>>? builder;
  final WidgetFromDataBuilder2<int, ImagePickerController>? imagePickerBuilder;
  final bool showAddButton;
  final WidgetFromDataBuilder<BuildContext>? addButtonBuilder;
  final WidgetFromDataBuilder<BuildContext>? addButtonIconBuilder;
  final WidgetFromDataBuilder2<VoidCallback, VoidCallback>? popUpChild;
  final WidgetFromDataBuilder<VoidCallback>? buttonCamera;
  final WidgetFromDataBuilder<VoidCallback>? buttonGalery;
  final BoxDecoration? popUpDecoration;
  final EdgeInsetsGeometry? popUpMargin;
  final EdgeInsetsGeometry? popUpPadding;
  final double? popUpHeight;
  final double? popUpWidth;
  final int? imageQuality;
  final ValueChanged<ImagePickerController>? onTap;
  final String? uploadUrl;
  final String? deleteUrl;
  final String? token;
  final ValueChanged<File?>? onImageLoaded;
  final ValueChanged<String>? onUploaded;
  final ValueChanged<dynamic>? onUploadFailed;
  final ObjectBuilderWithParam<Future<bool>, ImagePickerController>?
      onDeleteImage;
  final VoidCallback? onImageDeleted;
  final double? size;
  final bool showButtonDelete;
  final List<WidgetFromDataBuilder<ImagePickerValue>>
      imagePickerPlaceHolderContainers;
  final VoidCallback? onStartGetImage;
  final VoidCallback? onEndGetImage;
  final String? selectPhotoLabel;
  final String? openCameraLabel;
  final String? openGalleryLabel;
  final ValueChanged<List<ImagePickerController?>?>? onChange;
  final int? maxCount;

  const MultipleImagePickerComponent({
    super.key,
    required this.controller,
    this.placeHolder,
    this.addIcon,
    this.camera = true,
    this.galery = true,
    this.popUpAlign,
    this.popUpDecoration,
    this.popUpMargin,
    this.popUpPadding,
    this.popUpHeight,
    this.popUpWidth,
    this.popUpChild,
    this.buttonCamera,
    this.buttonGalery,
    this.imagePickerBuilder,
    this.showAddButton = true,
    this.addButtonBuilder,
    this.addButtonIconBuilder,
    this.onTap,
    this.builder,
    this.imageQuality,
    this.uploadUrl,
    this.deleteUrl,
    this.token,
    this.onUploaded,
    this.onUploadFailed,
    this.onDeleteImage,
    this.size,
    this.onImageLoaded,
    this.onImageDeleted,
    this.showButtonDelete = true,
    this.imagePickerPlaceHolderContainers = const [],
    this.onEndGetImage,
    this.onStartGetImage,
    this.selectPhotoLabel,
    this.openCameraLabel,
    this.openGalleryLabel,
    this.onChange,
    this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MultipleImagePickerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        controller.value.context = context;
        return controller.value.imagePickerControllers!.isEmpty
            ? placeHolder == null || placeHolder?.call(context) == null
                ? inputImage(context, value.imagePickerControllers!)
                : placeHolder!(context)
            : inputImage(context, value.imagePickerControllers!);
      },
    );
  }

  Widget inputImage(BuildContext context,
      List<ImagePickerController> imagePickerControllers) {
    return builder != null
        ? builder!(inputImageBuilder(context, imagePickerControllers))
        : Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: inputImageBuilder(context, imagePickerControllers),
            ),
          );
  }

  Widget imgPickerBuilder(
      int index, ImagePickerController imagePickerController) {
    return Container(
      height: size != null ? (size! + 5) : 115,
      width: size ?? 110,
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              height: size != null ? (size! - 5) : 100,
              width: size != null ? (size! - 5) : 100,
              child: ImagePickerComponent(
                containerHeight: size != null ? (size! - 5) : 100,
                containerWidth: size != null ? (size! - 5) : 100,
                camera: camera,
                galery: galery,
                controller: imagePickerController,
                onTap: onTap,
                imageQuality: imageQuality,
                uploadUrl: uploadUrl,
                deleteUrl: deleteUrl,
                token: token,
                onUploaded: (val) {
                  controller.setState(() {
                    if (onUploaded != null) {
                      onUploaded!(val);
                    }
                  });
                },
                onUploadFailed: onUploadFailed,
                onImageLoaded: onImageLoaded,
                placeHolderContainer:
                    imagePickerPlaceHolderContainers.length - 1 >= index
                        ? imagePickerPlaceHolderContainers[index]
                        : null,
                onChange: (val) {
                  if (onChange != null) {
                    onChange!(controller.value.imagePickerControllers);
                  }
                },
              ),
            ),
          ),
          showButtonDelete &&
                  // imagePickerController.isValid &&
                  imagePickerPlaceHolderContainers.length - 1 < index
              ? Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        if (onDeleteImage != null) {
                          onDeleteImage!(imagePickerController).then(
                            (value) {
                              if (value == true) {
                                controller.remove(index);
                                if (onImageDeleted != null) {
                                  onImageDeleted!();
                                }
                              }
                            },
                          );
                        } else {
                          controller.remove(index);
                          if (onImageDeleted != null) {
                            onImageDeleted!();
                          }
                        }
                      },
                      child: IconButton(
                        icon: const Icon(FontAwesomeIcons.timesCircle),
                        onPressed: () {
                          if (onDeleteImage != null) {
                            onDeleteImage!(imagePickerController).then(
                              (value) {
                                if (value == true) {
                                  controller.remove(index);
                                  onChange!(
                                      controller.value.imagePickerControllers);
                                  if (onImageDeleted != null) {
                                    onImageDeleted!();
                                  }
                                }
                              },
                            );
                          } else {
                            controller.remove(index);
                            onChange!(controller.value.imagePickerControllers);
                            if (onImageDeleted != null) {
                              onImageDeleted!();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  //Ada perubahan  pada icon , borderColor decorationBox, width dan height Container  untuk kebutuhan ImagePicker di module Absen

  Widget addBtnBuilder(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Center(
        // child: Icon(
        //   //Icons.add,
        //   size: 50,
        //   color: Colors.grey,
        // ),
        child: addButtonIconBuilder != null
            ? addButtonIconBuilder!(context)
            : const Icon(
                Icons.camera_alt,
                size: 30,
                color: Colors.grey,
              ),
        // child: SvgPicture.asset(
        //   "assets/add_rounded.svg",
        //   color: System.data.colorUtil.color009789,
        //   width: 25,
        //   height: 25,
        // ),
      ),
    );
  }

  List<Widget> inputImageBuilder(BuildContext context,
      List<ImagePickerController> imagePickerControllers) {
    List<Widget> widget = [];
    List.generate(imagePickerControllers.length, (i) {
      widget.add(imagePickerBuilder != null
          ? imagePickerBuilder!(i, imagePickerControllers[i])
          : imgPickerBuilder(i, imagePickerControllers[i]));
    });

    if (showAddButton == true) {
      widget.add(GestureDetector(
        onTap: () {
          if (camera == true && galery == true) {
            openModal(context);
          } else {
            controller.add(
              camera: camera,
              onImageLoaded: onImageLoaded,
              onEndGetImage: onEndGetImage,
              onStartGetImage: onStartGetImage,
              onChange: (val) {
                if (onChange != null) {
                  onChange!(controller.value.imagePickerControllers);
                }
              },
            );
          }
        },
        child: (maxCount != null &&
                imagePickerControllers.length >= (maxCount ?? 0))
            ? const SizedBox()
            : addButtonBuilder != null
                ? addButtonBuilder!(context)
                : addBtnBuilder(context),
      ));
    }
    return widget;
  }

  void openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 1,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.red.withOpacity(0),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop("modal");
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.0),
            child: Align(
              alignment: popUpAlign ?? Alignment.bottomCenter,
              child: Container(
                height: popUpHeight ?? 170,
                width: popUpWidth ?? double.infinity,
                margin: popUpMargin ??
                    (popUpAlign == Alignment.center
                        ? const EdgeInsets.only(left: 10, right: 20)
                        : null),
                padding: popUpPadding ?? const EdgeInsets.all(20),
                decoration: popUpDecoration ??
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: popUpAlign == Alignment.center
                            ? const Radius.circular(20)
                            : Radius.zero,
                        bottomRight: popUpAlign == Alignment.center
                            ? const Radius.circular(20)
                            : Radius.zero,
                      ),
                    ),
                child: popUpChild != null
                    ? popUpChild!(() {
                        openCamera(context);
                      }, () {
                        openGalery(context);
                      })
                    : Column(
                        children: <Widget>[
                          Text(
                            selectPhotoLabel ?? 'Select Photo',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buttonCamera != null
                              ? buttonGalery!(() {
                                  openGalery(context);
                                })
                              : SizedBox(
                                  height: 35,
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      openCamera(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Text(
                                      openCameraLabel ?? 'Camera',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          buttonGalery != null
                              ? buttonGalery!(() {
                                  openGalery(context);
                                })
                              : SizedBox(
                                  height: 35,
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      openGalery(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Text(
                                      openGalleryLabel ?? 'Gallery',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void openGalery(BuildContext context) {
    Navigator.of(context).pop();
    controller.add(
      camera: false,
      onImageLoaded: onImageLoaded,
      onEndGetImage: onEndGetImage,
      onStartGetImage: onStartGetImage,
      onChange: (p0) => onChange!(controller.value.imagePickerControllers),
    );
  }

  void openCamera(BuildContext context) {
    Navigator.of(context).pop();
    controller.add(
      camera: true,
      onImageLoaded: onImageLoaded,
      onEndGetImage: onEndGetImage,
      onStartGetImage: onStartGetImage,
      onChange: (p0) => onChange!(controller.value.imagePickerControllers),
    );
  }
}

class MultipleImagePickerController
    extends ValueNotifier<MultipleImagePickerValue> {
  MultipleImagePickerController({MultipleImagePickerValue? value})
      : super(value ?? MultipleImagePickerValue());

  bool? isValid;

  void add(
      {bool camera = true,
      ValueChanged<File?>? onImageLoaded,
      VoidCallback? onStartGetImage,
      VoidCallback? onEndGetImage,
      Function(ImagePickerController)? onChange}) {
    value.imagePickerControllers!.add(ImagePickerController());
    value.imagePickerControllers!.last.value.context = value.context;
    notifyListeners();
    value.imagePickerControllers!.last.getImages(
      camera: camera,
      onImageLoaded: onImageLoaded,
      onStartGetImage: onStartGetImage,
      onEndGetImage: onEndGetImage,
      onChange: onChange,
    );
  }

  void addEMpty() {
    value.imagePickerControllers!.add(
      ImagePickerController(value: ImagePickerValue()),
    );
  }

  void remove(int index) {
    value.imagePickerControllers!.removeAt(index);
    notifyListeners();
  }

  void clear() {
    value.imagePickerControllers!.clear();
    notifyListeners();
  }

  List<String?> getBase64() {
    List<String?> result = [];
    for (ImagePickerController controller in value.imagePickerControllers!) {
      result.add(controller.getBase64());
    }
    return result;
  }

  List<String?> getBase64Compress() {
    List<String?> result = [];
    for (ImagePickerController controller in value.imagePickerControllers!) {
      result.add(controller.getBase64Compress());
    }
    return result;
  }

  List<dynamic> getUploadedImageId() {
    List<dynamic> result = [];
    for (ImagePickerController controller in value.imagePickerControllers!) {
      if (controller.value.uploadedId != null) {
        result.add(controller.value.uploadedId);
      }
    }
    return result;
  }

  List<File?> getFile() {
    List<File?> result = [];
    for (ImagePickerController controller in value.imagePickerControllers!) {
      result.add(controller.getFile());
    }
    return result;
  }

  bool validate() {
    bool? result = true;
    for (ImagePickerController controller in value.imagePickerControllers!) {
      // result = controller.getBase64().isNullOrEmpty() ? false : null;
      result = controller.validate();
      if (result == false) {
        return false;
      }
    }
    return result ?? true;
  }

  int length() {
    return value.imagePickerControllers!.length;
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

class MultipleImagePickerValue {
  BuildContext? context;
  List<ImagePickerController>? imagePickerControllers;

  MultipleImagePickerValue({
    this.context,
    this.imagePickerControllers,
  }) {
    imagePickerControllers ??= [];
  }
}
