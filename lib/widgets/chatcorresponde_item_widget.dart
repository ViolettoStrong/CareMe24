import 'package:careme24/blocs/service/model_chat.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/app_decoration.dart';
import '../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class ChatcorrespondeItemWidget extends StatefulWidget {
  String photo;
  String name;
  int lastMessage;
  String specialization;
  LastMessage? last_message;
  // late bool isSelectedVisibler;
  ChatcorrespondeItemWidget({
    super.key,
    required this.photo,
    required this.name,
    required this.lastMessage,
    required this.specialization,
    required this.last_message,
    // required this.isSelectedVisibler,
  });

  @override
  State<ChatcorrespondeItemWidget> createState() =>
      _ChatcorrespondeItemWidgetState();
}

class _ChatcorrespondeItemWidgetState extends State<ChatcorrespondeItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          shape: const RoundedRectangleBorder(
              //side:  BorderSide(color: Colors.green,width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              CustomImageView(
                width: 60,
                fit: BoxFit.cover,
                url: widget.photo,
                // imagePath: ImageConstant.imgRectangle2626,
                height: getVerticalSize(
                  86,
                ),
                radius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    getHorizontalSize(
                      24,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: getPadding(
                  left: 12,
                  top: 4,
                  right: 5,
                  bottom: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: getMargin(
                            top: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.specialization,
                                  style: TextStyle(
                                    color: ColorConstant.blue60001,
                                    fontSize: getFontSize(
                                      12,
                                    ),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: '\n'),
                                TextSpan(
                                  text: widget.name,
                                  style: TextStyle(
                                    color: ColorConstant.blue60001,
                                    fontSize: getFontSize(
                                      15,
                                    ),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstant.blue60001,
                              borderRadius:
                                  BorderRadiusStyle.txtRoundedBorder10),
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                widget.lastMessage.toString(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFontSize(
                                    10,
                                  ),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: getPadding(
                        top: 10,
                        right: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //     width: MediaQuery.of(context).size.width / 6,
                          //     child: Text(
                          //       '',
                          //       overflow: TextOverflow.ellipsis,
                          //       textAlign: TextAlign.left,
                          //       style: AppStyle.txtMontserratMedium10,
                          //     )),
                          Padding(
                            padding: getPadding(
                              left: 5,
                            ),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: Text(
                                  'Последнее сообщение: ${widget.last_message?.text ?? ""}',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtMontserratRegular10,
                                )),
                          ),
                          Padding(
                            padding: getPadding(
                              left: 6,
                            ),
                            child: Text(
                              "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ColorConstant.gray500,
                                fontSize: getFontSize(
                                  10,
                                ),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        // Visibility(
        //   visible: widget.isSelectedVisibler,
        //   child: Container(
        //       width: MediaQuery.of(context).size.width - 50,
        //       height: getVerticalSize(
        //         86,
        //       ),
        //       decoration: const BoxDecoration(
        //           color: Color.fromRGBO(51, 132, 226, 0.7),
        //           borderRadius: BorderRadius.all(Radius.circular(10))),
        //       child: Stack(
        //         children: [
        //           GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   widget.isSelectedVisibler = false;
        //                 });
        //               },
        //               child: Align(
        //                 alignment: Alignment.topRight,
        //                 child: Padding(
        //                     padding: const EdgeInsets.only(top: 12, right: 18),
        //                     child: Text(
        //                       'Отмена',
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: getFontSize(
        //                           9,
        //                         ),
        //                         fontFamily: 'Montserrat',
        //                         fontWeight: FontWeight.w600,
        //                       ),
        //                     )),
        //               )),
        //           GestureDetector(
        //               onTap: () {
        //                 //Удаление чата
        //               },
        //               child: Align(
        //                   alignment: Alignment.center,
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       const Icon(
        //                         Icons.delete,
        //                         size: 24,
        //                         color: Colors.white,
        //                       ),
        //                       Text(
        //                         'Удалить чат',
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: getFontSize(
        //                             12,
        //                           ),
        //                           fontFamily: 'Montserrat',
        //                           fontWeight: FontWeight.w600,
        //                         ),
        //                       )
        //                     ],
        //                   ))),
        //         ],
        //       )),
        // ),
      ],
    );
  }
}
