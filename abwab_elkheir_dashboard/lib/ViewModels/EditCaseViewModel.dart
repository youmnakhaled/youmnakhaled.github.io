// import '../Constants/Endpoints.dart';

import '../Constants/ConstantColors.dart';
import '../Models/case_model.dart';
import '../Services/WebServices.dart';
import '../Services/UtilityFunctions.dart';
import 'package:flutter/material.dart';

class EditCaseViewModel with ChangeNotifier {
  Case caseToEdit;
  Case currentCase;
  Status status = Status.success;

  TextEditingController editCaseTitleController = TextEditingController();
  TextEditingController editCaseDescriptionController = TextEditingController();
  TextEditingController editCaseTotalPriceController = TextEditingController();
  TextEditingController editCaseStatusController = TextEditingController();

  void setCaseToEdit(Case caseToEdit) {
    this.caseToEdit = caseToEdit;
  }

  Future<void> editCase(BuildContext context, String token) async {
    try {
      status = Status.loading;
      notifyListeners();
      print('Adding');
      Map<String, dynamic> results = await WebServices().editCase(
          caseToEdit.id,
          caseToEdit.title,
          caseToEdit.description,
          caseToEdit.totalPrice,
          caseToEdit.images,
          caseToEdit.isActive,
          caseToEdit.status,
          caseToEdit.category,
          token);
      print(results);

      if (results['statusCode'] == 400) {
        UtilityFunctions.showErrorDialog(
            " خطأ",
            " حدث خطأ ما ، يرجى المحاولة مرة أخرى والتحقق من اتصالك بالإنترنت",
            context);
      }

      print(results['statusCode']);
      if (results['statusCode'] == 201) {
        UtilityFunctions.showErrorDialog(
            " تم الاضافة ", "تم اضافة الحالة بنجاح", context);

        editCaseTitleController.clear();
        editCaseDescriptionController.clear();
        editCaseTotalPriceController.clear();
        editCaseStatusController.clear();
        currentCase = caseToEdit;
        caseToEdit = null;
      }

      status = Status.success;
      notifyListeners();

      status = Status.success;
      notifyListeners();
    } catch (error) {
      return;
    }
  }
}
