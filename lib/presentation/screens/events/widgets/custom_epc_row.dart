import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';

class CustomEpcRow extends StatelessWidget {
  final String article;
  final String epc;
  final String urlImage;
  final String gtin;
  final String eventId;
  final String technology;


  const CustomEpcRow({super.key, required this.article, required this.epc, required this.urlImage, required this.gtin, required this.eventId, required this.technology});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: 
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  article != "" ?
                  Text(article,
                  style: TextStyle(
                    fontSize: technology == "rf" ? 15 : 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.clip
                    )
                  ) :
                  Text(AppLocalizations.of(context)!.no_description,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  
                  SizedBox(height: technology=="rf" || eventId=="JAMMER" ? 0 : 10),
                  gtin != "" ? Text(gtin,
                    style: TextStyle(
                      fontSize: technology=="rf" || eventId=="JAMMER" ? 17 : 12,
                      fontWeight: technology=="rf" || eventId=="JAMMER" ? FontWeight.w600 :FontWeight.w500
                    )
                  ): SizedBox(),
                  Text(epc,
                    style: TextStyle(
                      fontSize: technology=="rf" || eventId=="JAMMER" ? 16 : 12,
                      fontWeight: technology=="rf" || eventId=="JAMMER" ? FontWeight.w700 : FontWeight.w300
                    )
                  )
                ]
              )
            )
          ),
          Expanded(
            flex:  technology=="rf" || eventId=="JAMMER" ? 1: 3,
            child: technology=="rf" || eventId=="JAMMER" ? SizedBox(): 
            Center(
              child: urlImage != "" ? 
              Image.network(
                urlImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return  
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      Icon(Icons.grid_off_sharp,
                        color: AppTheme.extraColor,
                        size: 40             
                      ),
                      Text(AppLocalizations.of(context)!.image_break, 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          overflow: TextOverflow.clip
                        )
                      )
                    ]
                  );
                },
              ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Icon(Icons.photo_size_select_actual_outlined,
                      color: AppTheme.extraColor,
                      size: 40             
                    ),
                    Text(AppLocalizations.of(context)!.image_unavailable, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.buttonsColor,
                        fontSize: 12,
                        overflow: TextOverflow.clip
                      )
                    )
                  ]
                )
            )
          )
        ]
      );
    }
  }