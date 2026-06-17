import 'package:flutter/material.dart';
import 'package:verirent/core/api/domain/entities/agency_model.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key, required this.agency});

  final AgencyModel agency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // todo: update the viewProfile page with a production-ready template.
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [Text(agency.name!), Text('${agency.rating!}')],
        ),
      ),
    );
  }
}
