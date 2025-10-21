import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
//import 'package:storeops_mobile/data/models/enrich_firebase_model.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_epc_row.dart';

class CustomExpandEvent extends StatefulWidget {
  final String timestamp;
  final String groupId;
  final List<Map<String, dynamic>>? enrich;
  // final List<EnrichFirebaseModel>? enrich;
  final bool silent;
  final String storeSelected;
  final String storeName;
  final String eventId;
  final String technology;

  const CustomExpandEvent({super.key, required this.timestamp, required this.groupId, required this.enrich, required this.silent, required this.storeSelected, required this.storeName, required this.eventId, required this.technology});

  @override
  State<CustomExpandEvent> createState() => _CustomExpandEventState();
}

class _CustomExpandEventState extends State<CustomExpandEvent> {
  bool _expanded = false;

  

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.buttonsColor, width: 1),
        borderRadius: BorderRadius.circular(5)
      ),
      color: Colors.white,
      elevation: 1,
      shadowColor: AppTheme.primaryColor,
      child:
       Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        InkWell(
          onTap: _toggleExpanded,
          child: 
          Column(
            children: [ 
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: 
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(15, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.timestamp.substring(0,widget.timestamp.length-4),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          Text('${widget.storeSelected}- ${widget.storeName} - ${widget.groupId}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w300
                            ),
                          )                   
                        ],
                      ),
                    )
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.eventId == "rfid_alarm" ? AppTheme.buttonsColor 
                            : widget.technology == "rf" ? AppTheme.forgottenColor : Colors.blue,
                          ),
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: widget.eventId == "rfid_alarm" ? 8 :
                            widget.eventId == "rfid_sale" ? 8: 15),
                            child: 
                              Text(widget.eventId == "rfid_alarm" ? 'RFID' 
                              : widget.technology == "rf" ? 'RF' : 'SOLD', 
                                style: TextStyle(color: Colors.white, fontSize: 14)
                              )
                          ),
                        ),
                        widget.eventId == "rfid_alarm" || widget.technology == "rf" ?
                        !widget.silent ? 
                        Icon(Icons.volume_up_outlined,
                          color: AppTheme.buttonsColor
                        ): 
                        Icon(Icons.volume_off_outlined, color: AppTheme.buttonsColor)
                        : SizedBox()
                      ]
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0, 13, 5, 0),
                  child: Column(
                    children:[ 
                      Text(widget.enrich!.length.toString(), style: TextStyle(fontSize: 11),),
                      Icon(
                      _expanded ? Icons.remove : Icons.add,
                      size: 24,
                      color: AppTheme.secondaryColor,
                      )
                    ]
                  ),
                ),
              ],
            ),
            Divider(),
            widget.eventId == "rfid_forgotten" ?
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.forgottenColor
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
                      child: Text(AppLocalizations.of(context)!.forgotten_tag, style: TextStyle(
                        fontSize: 12, color: Colors.white
                      ),),
                    ),
                  ): SizedBox(),
          
            SizedBox(
              height: 100,
              child: 
                widget.enrich != null ?
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0), 
                  child: 
                  CustomEpcRow(
                    article: widget.enrich![0]["description"], 
                    epc: widget.enrich![0]["epc"], 
                    urlImage: widget.enrich![0]["imageUrl"],
                    gtin: widget.enrich![0]["gtin"],
                    eventId: widget.eventId,
                    technology: widget.technology,
                  )
                )
                :Text('dbf')
          )
          ]
        ),
      
        ),

        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Column(
            children: 
              widget.enrich!.skip(1).map((item) => 
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(10, 10, 0, 10),  
                      child: CustomEpcRow(
                        article: item["description"], 
                        epc: item["epc"], 
                        urlImage: item["imageUrl"],
                        gtin: item["gtin"],
                        eventId: widget.eventId,
                        technology: widget.technology,
                        )
                    )
                    ).toList()
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    )
  );
  }
}



        // ExpansionTile(
        //   tilePadding: EdgeInsetsGeometry.fromLTRB(0,0,0,0),
        //   childrenPadding: EdgeInsets.fromLTRB(0, 0, 30, 0),
        //   trailing: _expanded ? Icon(Icons.remove, size: 30, color: AppTheme.primaryColor,):
        //   Icon(Icons.add, size: 30, color: AppTheme.primaryColor,),
        //   onExpansionChanged: (bool expanded) {
        //     setState(() {
        //       _expanded = expanded;
        //     });
        //   },
        //   title:Column(
        //     children:[
        //       SizedBox(
        //         height: 55,
        //         child: Row(
        //           children: [
        //             Expanded(
        //               flex: 7,
        //               child: Padding(
        //                 padding: EdgeInsetsGeometry.fromLTRB(15, 0, 0, 0),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       widget.timestamp.substring(0,widget.timestamp.length-4),
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: AppTheme.primaryColor,
        //                         fontWeight: FontWeight.w500,
        //                         overflow: TextOverflow.ellipsis
        //                       )
        //                     ),
        //                     Text('${widget.storeSelected} (${widget.storeName}) - ${widget.groupId}',style: 
        //                       TextStyle(
        //                         fontSize: 12,
        //                         color: AppTheme.primaryColor,
        //                         fontWeight: FontWeight.w300,
        //                         overflow: TextOverflow.ellipsis
        //                       )
        //                     ),
        //                   ]
        //                 ),
        //               )
        //             ),
        //             Expanded(
        //               flex: 3,
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(10),
        //                       color: AppTheme.buttonsColor,
        //                     ),
        //                     child: 
        //                       Padding(
        //                         padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 8),
        //                         child: Text('RFID', 
        //                           style: TextStyle(color: Colors.white, fontSize: 14)
        //                         )
        //                       ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsetsGeometry.symmetric(vertical: 5,horizontal: 0),
        //                     child: !widget.silent ? 
        //                     Icon(Icons.volume_up_outlined,
        //                       color: AppTheme.buttonsColor
        //                     ) : 
        //                     Icon(Icons.volume_off_outlined, color: AppTheme.buttonsColor) 
        //                   )
        //                 ]
        //               )
        //             )
        //           ]
        //         )
        //       ),
        //       Divider(),
        //       widget.enrich != null ?
        //       Padding(
        //         padding: EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0), child: CustomEpcRow(article: widget.enrich![0].description, epc: widget.enrich![0].epc, urlImage: widget.enrich![0].imageUrl))
        //       :Text('dbf')
        //     ]
        //   ),
        //   children: [
        //     ListTile(
        //       title: Column(
        //         children:
        //           widget.enrich!.skip(1).map((item) => 
        //           CustomEpcRow(
        //             article: item.description, 
        //             epc: item.epc, 
        //             urlImage: item.imageUrl)
        //           ).toList()
        //         )
        //       )
        //     ]
        //   )

