import 'package:countero/forms/new_cost_record_controllers.dart';
import 'package:countero/forms/new_cost_record_form.dart';
import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile_model.dart';
import 'package:countero/pages/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CreateCostRecord extends StatefulWidget {
  @override
  _CreateCostRecordState createState() => _CreateCostRecordState();
}

class _CreateCostRecordState extends State<CreateCostRecord> {
  final costRecordControllers = NewCostRecordControllers();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context).settings.arguments;
    int costRecordIdx;
    if (args != null) {
      costRecordIdx = int.parse(args);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args != null ? "Edytuj rekord" : "Dodaj rekord"),
        actions: [
          Visibility(
            visible: costRecordIdx != null,
            child: TextButton(
                onPressed: () => deleteCostRecord(costRecordIdx),
                child: Icon(Icons.delete_outlined, color: Theme.of(context).iconTheme.color),
            ),
          )
        ],
      ),
      body: NewCostRecordForm(
        costRecordIdx: costRecordIdx,
        formKey: formKey,
        controllers: costRecordControllers,
      ),
      floatingActionButton: CustomSaveButton(
          formKey: formKey, onClick: () => saveCostRecord(costRecordIdx)
      ),
    );
  }

  saveCostRecord(int expenseIdx) {
    CostRecord record = controllersToCostRecord(costRecordControllers);
    print(record.categoryId);
    var profileModel = Provider.of<ProfileModel>(context, listen: false);
    expenseIdx == null
        ? profileModel.saveSingleCostRecord(record)
        : profileModel.saveSingleCostRecordWithIndex(expenseIdx, record);
    Navigator.pop(context);
  }

  deleteCostRecord(int expenseIdx) {
    var profileModel = Provider.of<ProfileModel>(context, listen: false);
    profileModel.deleteCostRecordByIndex(expenseIdx);
    Navigator.pop(context);
  }
}