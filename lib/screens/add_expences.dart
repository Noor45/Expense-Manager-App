import 'dart:convert';
import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/compensation_list_model.dart';
import '../model/department_expense_list_model.dart';
import '../model/employee_list_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api/networkUtils.dart';
import '../model/expense_type_model.dart';
import '../model/payment_model.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/empty_widget.dart';
import '../widgets/input_filed.dart';
import 'bank_transaction_screen.dart';

class AddExpenses extends StatefulWidget {
  static String addExpenseScreenID = "/add_expense_screen";
  const AddExpenses({Key? key}) : super(key: key);

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  int? selectedExpenseItem = 0;
  int? selectedGeneral = 0;
  int? selectedBusiness = 0;
  int? selectedEveryDayExpense = 0;
  int? selectedDept = 0;
  int? selectedDeptExpense = 0;
  int? selectedDeptToolsExpense = 0;
  int? selectedCompassion = 0;
  int? selectedEmployee = 0;
  int? selectedBank = 0;
  int? selectedUser = 0;
  int? selectedPaymentMode = 0;
  String? description;
  String? amount;
  String? selectedDate;
  bool showGeneral = true;
  bool showBusiness = false;
  bool showEveryDayExpense = false;
  bool showDept = false;
  bool showDeptExpense = false;
  bool showDeptToolsExpense = false;
  bool showCompassion = false;
  bool showEmployee = false;

  TextEditingController desController = TextEditingController();
  File? image;
  final picker = ImagePicker();
  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage = await picker.pickImage(source: imageSource);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  String? selectedSubexpense;
  String? selectedDepartmentExpense;
  String? selectedDepartmentSubcategory;
  String? selectedEmployeeOption;
  String? fieldTitle = '';
  bool showAdditionalField = false;
  bool showEmployeeField = false;
  List<PaymentModel> paymentModes = Constants.listPaymentMode ?? [];
  Map<String, int> paymentModeMap = {
    for (var mode in Constants.listPaymentMode ?? [])
      if (mode.name != null) mode.name!: mode.id ?? 0
  };
  XFile? _image;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  // List<ExpenseTypeModel> category = Constants.typeExpense ?? [];
  Map<String, int> categoryModeMap = {
    for (var mode in Constants.typeExpense ?? [])
      if (mode.expenseName != null) mode.expenseName!: mode.expenseTypeId ?? 0
  };
  // List<GeneralTypeExpenseModel> generalExpenseList = Constants.generalExpenseList ?? [];
  Map<String, int> generalExpenseListModeMap = {
    for (var mode in Constants.generalExpenseList ?? [])
      if (mode.name != null && mode.status == 0) mode.name!: mode.id ?? 0
  };
  // List<BusinessTypeExpenseModel> businessExpenseList = Constants.businessExpenseList ?? [];
  // Map<String, int> businessExpenseListModeMap = {
  //   for (var mode in Constants.businessExpenseList ?? [])
  //     if (mode.name != null && mode.status == 0) mode.name!: mode.id ?? 0
  // };

  Map<String, Map<String, int>> businessExpenseListModeMap = {
    for (var mode in Constants.businessExpenseList ?? [])
      if (mode.name != null && mode.status == 0)
        mode.name!: {
          'id': mode.id ?? 0,
          'kuch': mode.kuch ?? 0
        }
  };

  // List<DepartmentModel> departments = Constants.departments ?? [];
  Map<String, int> departmentsModeMap = {
    for (var mode in Constants.departments ?? [])
      if (mode.deptName != null && mode.status == 0) mode.deptName!: mode.id ?? 0
  };
  List<DepartmentTypeExpenseModel> departmentExpenseList = Constants.departmentExpenseList ?? [];
  Map<String, int> departmentExpenseListModeMap = {
    for (var mode in Constants.departmentExpenseList ?? [])
      if (mode.name != null) mode.name!: mode.id ?? 0
  };
  // List<DepartmentPurchaseModel> departmentToolsExpenseList = Constants.dptPurchasingList ?? [];
  Map<String, int> dptPurchasingListModeMap = {
    for (var mode in Constants.dptPurchasingList ?? [])
      if (mode.name != null && mode.status == 0) mode.name!: mode.id ?? 0
  };
  // List<EveryDayExpenseModel> everydayExpenseList = Constants.everydayExpenseList ?? [];
  Map<String, int> everydayExpenseListModeMap = {
    for (var mode in Constants.everydayExpenseList ?? [])
      if (mode.name != null && mode.status == 0) mode.name!: mode.id ?? 0
  };
  // List<CompensationModel> compensationList = Constants.compensationList ?? [];
  Map<String, int> compensationListModeMap = {
    for (var mode in Constants.compensationList ?? [])
      if (mode.type != null) mode.type!: mode.id ?? 0
  };
  // List<EmployeeListModel> employeesList = Constants.employeesList ?? [];
  Map<String, int> employeesListModeMap = {
    for (var mode in Constants.employeesList ?? [])
      if (mode.name != null && mode.status == 0) mode.name!: mode.id ?? 0
  };
  // List<BankModel> bankList = Constants.bankList ?? [];
  Map<String, int> bankListModeMap = {
    for (var mode in Constants.bankList ?? [])
      if (mode.bankName != null && mode.status == 0) mode.bankName!: mode.id ?? 0
  };
  // List<UserModel> userList = Constants.userLists ?? [];
  // Map<String, int> userListModeMap = {
  //   for (var mode in Constants.userLists ?? [])
  //     if (mode.name != null) mode.name!: mode.uid ?? 0
  // };
  Map<String, int> userListModeMap = {
    for (var mode in Constants.userLists ?? [])
      if (mode.name != null)
        if (mode.uid == Constants.userDetail!.uid!)
          'Self_${mode.uid}': mode.uid!
        else
          '${mode.name!}_${mode.uid}': mode.uid!
  };

  List<String> items = [];

  @override
  void initState() {
    // TODO: implement initState
   items = userListModeMap.keys.toList();
   items.sort((a, b) {
      if (a.startsWith('Self')) return -1;
      if (b.startsWith('Self')) return 1;
      return 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(
        color: ColorRefer.kPrimaryColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_sharp
                  : Icons.arrow_back_rounded,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: ColorRefer.kPrimaryColor,
          title: const Text(
            'Add Expense',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: bankListModeMap.isEmpty ? Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('No bank transaction to show', context),) : SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: DropdownField(
                          label: 'Select Expense Category',
                          hintText: 'Choose item',
                          items: categoryModeMap.keys.toList(),
                          onTap: () {
                            if(categoryModeMap.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('There is no data in the dropdown')),
                              );
                            }
                          },
                          onChanged: (value) {

                            int? selectedId = categoryModeMap[value];
                            if(selectedId == 1) {
                              setState(() {
                                showGeneral = true;
                                showBusiness = false;
                                showEveryDayExpense = false;
                                showDept = false;
                                showDeptExpense = false;
                                showDeptToolsExpense = false;
                                showCompassion = false;
                                showEmployee = false;
                                selectedBusiness = 0;
                                selectedEveryDayExpense = 0;
                                selectedDept = 0;
                                selectedDeptExpense = 0;
                                selectedDeptToolsExpense = 0;
                                selectedCompassion = 0;
                                selectedEmployee = 0;
                              });
                            }  else if(selectedId == 2) {
                              setState(() {
                                showBusiness = true;
                                showGeneral = false;
                                selectedGeneral = 0;
                              });
                            }
                            selectedExpenseItem = selectedId;
                            fieldTitle = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an item';
                            }
                            return null;
                          },
                        ),
                      ),
                      Visibility(
                        visible: showGeneral,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select $fieldTitle',
                            hintText: 'Choose an item',
                            items: generalExpenseListModeMap.keys.toList(),
                            onTap: () {
                              if(generalExpenseListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = generalExpenseListModeMap[value];
                              setState(() {
                                selectedGeneral = selectedId;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showBusiness,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select $fieldTitle',
                            hintText: 'Choose an item',
                            items: businessExpenseListModeMap.keys.toList(),
                            onTap: () {
                              if(businessExpenseListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = businessExpenseListModeMap[value]?['id'];
                              int? selectedStatus = businessExpenseListModeMap[value]?['kuch'];
                              setState(() {
                                selectedBusiness = selectedId;
                              });
                              if(selectedStatus == 5) {
                                setState(() {
                                  showDept = true;
                                  showEveryDayExpense = false;
                                  selectedEveryDayExpense = 0;
                                });
                              }  else if(selectedStatus == 6) {
                                setState(() {
                                  showEveryDayExpense = true;
                                  showDept = false;
                                  showDeptExpense = false;
                                  showDeptToolsExpense = false;
                                  showCompassion = false;
                                  showEmployee = false;
                                  selectedDept = 0;
                                  selectedDeptExpense = 0;
                                  selectedDeptToolsExpense = 0;
                                  selectedCompassion = 0;
                                  selectedEmployee = 0;
                                });
                              }
                              // selectedItem = selectedId.toString();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showEveryDayExpense,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Everyday Item',
                            hintText: 'Choose an item',
                            items: everydayExpenseListModeMap.keys.toList(),
                            onTap: () {
                              if(everydayExpenseListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = everydayExpenseListModeMap[value];
                              setState(() {
                                selectedEveryDayExpense = selectedId;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showDept,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Department',
                            hintText: 'Choose Department',
                            items: departmentsModeMap.keys.toList(),
                            onTap: () {
                              if(departmentsModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = departmentsModeMap[value];
                              setState(() {
                                selectedDept = selectedId;
                                showDeptExpense = true;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showDeptExpense,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Department Expense',
                            hintText: 'Choose Department',
                            items: departmentExpenseListModeMap.keys.toList(),
                            onTap: () {
                              if(departmentExpenseListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = departmentExpenseListModeMap[value];
                              setState(() {
                                selectedDeptExpense = selectedId;
                              });
                              if(selectedId == 1) {
                                setState(() {
                                  showCompassion = true;
                                  showDeptToolsExpense = false;
                                  selectedDeptToolsExpense = 0;
                                });
                              }  else if(selectedId == 2) {

                                setState(() {
                                  showDeptToolsExpense = true;
                                  showCompassion = false;
                                  showEmployee = false;
                                  selectedCompassion = 0;
                                  selectedEmployee = 0;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showDeptToolsExpense,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Purchasing Tools',
                            hintText: 'Choose item',
                            items: dptPurchasingListModeMap.keys.toList(),
                            onTap: () {
                              if(dptPurchasingListModeMap.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no data in the dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = dptPurchasingListModeMap[value];
                              setState(() {
                                selectedDeptToolsExpense = selectedId;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Visibility(
                        visible: showCompassion,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Compensation',
                            hintText: 'Choose item',
                            items: compensationListModeMap.keys.toList(),
                            onTap: () {
                              if(compensationListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('There is no Compensation option dropdown')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = compensationListModeMap[value];
                              setState(() {
                                selectedCompassion = selectedId;
                              });
                              if(selectedId == 1) {
                                setState(() {
                                  List<EmployeeListModel>? employees = [];
                                  for (var element in Constants.employeesList!) {
                                    if(element.employeeType == 1 && element.dptId == selectedDept) employees.add(element);
                                  }
                                  if(employees.isEmpty){
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content:  Text('There is no Employee in this Department')),
                                    );
                                  }else{
                                    employeesListModeMap = {
                                      for (var mode in employees)
                                        if (mode.name != null)  mode.name!: mode.id ?? 0
                                    };
                                    setState(() {
                                      showEmployee = true;
                                    });
                                  }
                                });
                              }  else if(selectedId == 2) {
                                setState(() {
                                  List<EmployeeListModel>? investor = [];
                                  for (var element in Constants.employeesList!) {
                                    if(element.employeeType == 2 && element.dptId == selectedDept) investor.add(element);
                                  }
                                  if(investor.isEmpty) {
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content:  Text('There is no Investor in this Department')),
                                    );
                                  } else {
                                    employeesListModeMap = {
                                      for (var mode in investor)
                                        if (mode.name != null)  mode.name!: mode.id ?? 0
                                    };
                                    setState(() {
                                      showEmployee = true;
                                    });
                                  }
                                });
                              } else if(selectedId == 3) {
                                setState(() {
                                  List<EmployeeListModel>? contractor = [];
                                  for (var element in Constants.employeesList!) {
                                    if(element.employeeType == 3 && element.dptId == selectedDept) contractor.add(element);
                                  }
                                  employeesListModeMap = {
                                    for (var mode in contractor)
                                      if (mode.name != null)  mode.name!: mode.id ?? 0
                                  };
                                  if(contractor.isEmpty) {
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content:  Text('There is no Contractor in this Department')),
                                    );
                                  } else {
                                    employeesListModeMap = {
                                      for (var mode in contractor)
                                        if (mode.name != null)  mode.name!: mode.id ?? 0
                                    };
                                    setState(() {
                                      showEmployee = true;
                                    });
                                  }
                                });
                              }
                              // selectedItem = selectedId.toString();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Visibility(
                        visible: showEmployee,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: DropdownField(
                            label: 'Select Employees',
                            hintText: 'Choose item',
                            items: employeesListModeMap.keys.toList(),
                            onTap: () {
                              if(employeesListModeMap.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Employees not added')),
                                );
                              }
                            },
                            onChanged: (value) {
                              int? selectedId = employeesListModeMap[value];
                              setState(() {
                                selectedEmployee = selectedId;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: DropdownField(
                          label: 'Payment Mode',
                          hintText: 'Select Mode',
                          items: paymentModeMap.keys.toList(),
                          onTap: () {
                            if(paymentModeMap.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('There is no data in the dropdown')),
                              );
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              int? selectedId = paymentModeMap[value];
                              selectedPaymentMode = selectedId;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an item';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: InputField(
                          textInputType: TextInputType.number,
                          label: 'Amount',
                          validator: (firstName) {
                            if (firstName!.isEmpty) return "Name is required";
                            return null;
                          },
                          onChanged: (value){
                            setState(() {
                              amount = value;
                            });
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: DropdownField(
                          label: 'Select Bank',
                          hintText: 'Choose item',
                          items: bankListModeMap.keys.toList(),
                          onTap: () {
                            if(bankListModeMap.keys.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Banks not Exist')),
                              );
                            }
                          },
                          onChanged: (value) {
                            int? selectedId = bankListModeMap[value];
                            setState(() {
                              selectedBank = selectedId;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an item';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: DropdownField(
                          label: 'Transaction by',
                          hintText: 'Choose user',
                          items: items,
                          onChanged: (value) {
                            int? selectedId = userListModeMap[value];
                            setState(() {
                              selectedUser = selectedId;
                              print(selectedId);
                            });
                          },
                          onTap: () {
                            if(categoryModeMap.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('There is no data in the dropdown')),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an item';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SelectDateField(
                          label: 'DD/MM/YY',
                          hint: 'Select Date',
                          onChanged: (value){
                            setState(() {
                              if(value != null && value!='') {
                                // selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(value));
                                selectedDate = value;
                                // print(selectedDate);
                              }
                            });
                          },
                         ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: QuillField(
                          controller: desController,
                          textInputType: TextInputType.text,
                          enable: true,
                          label: 'Description',
                          hintText: 'Write here...',
                          borderColor: ColorRefer.kLabelColor,
                          validator: (value) {
                            if (value!.isEmpty) return "Description is required";
                            if (value.length < 3) return "Minimum three characters required";
                            return null;
                          },
                          onTaP: () async {},
                          onChanged: (value) => description = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            // Specify the image source, e.g., ImageSource.gallery or ImageSource.camera
                            pickImage(ImageSource.gallery);
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 125,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: ColorRefer.kLabelColor),
                                  ),
                                  child: image == null
                                      ? const Text('Choose file')
                                      : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 200.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 50),
                                child: Text(
                                  'Add Screenshot',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColorRefer.kLabelColor,
                                    fontFamily: FontRefer.OpenSans,
                                    backgroundColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,bottom: 25),
                  child: GestureDetector(
                    onTap: () {
                      _submitData(context);
                    },
                    child: Container(
                      width: 125,
                      height: 45,
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          color: ColorRefer.kPrimaryColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitData(BuildContext context) async {
    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (!formKey.currentState!.validate()) return;
      setState(() {
        isLoading = true;
      });
      var response;
      if (image != null) {
        var postResponse = await NetworkUtil.internal().uploadExpenseDataWithImage(
          selectedExpenseItem,
          selectedGeneral,
          selectedBusiness,
          selectedEveryDayExpense,
          selectedDept,
          selectedDeptExpense,
          selectedDeptToolsExpense,
          selectedCompassion,
          selectedEmployee,
          selectedBank,
          selectedPaymentMode,
          description,
          amount,
          selectedDate,
          image!,
          Constants.userDetail!.companyId.toString(),
        );
        response = postResponse;
      }
      else {
        print('Posting data without image...');
        var postResponse = await NetworkUtil.internal().post('add-expense',
          body: {
            'expense_type_id': selectedExpenseItem.toString(),
            'general_expense_id': selectedGeneral.toString(),
            'buisness_expense_id': selectedBusiness.toString(),
            'department_id': selectedDept.toString(),
            'departments_expense_id': selectedDeptExpense.toString(),
            'departments_purchase_id': selectedDeptToolsExpense.toString(),
            'departments_compensation_id': selectedCompassion.toString(),
            'departments_employee_id': selectedEmployee.toString(),
            'bank_id': selectedBank.toString(),
            'transaction_by': selectedUser.toString(),
            'payment_mode_id': selectedPaymentMode.toString(),
            'description': description,
            'amount': amount,
            'date': selectedDate,
            'user_id': Constants.userDetail!.uid.toString(),
            'company_id': Constants.userDetail!.companyId.toString(),
            'screenshot': '',
            'everyday_expense_id': selectedEveryDayExpense.toString(),
          },
        );
        response = postResponse?.body;
      }
      print('API Response: $response');

      final output = jsonDecode(response);
      if (output['code'] == 200) {
        setState(() {
          isLoading = false;
        });
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Your Expense added successfully')),
        );
        Constants.bankId = selectedBank;
        String bankName = '';
        Constants.bankList?.forEach((e) {
          if (e.id == Constants.bankId) {
            bankName = e.bankName!;
          }
        });
        if(Constants.userDetail!.access == 1){
          Navigator.pushReplacementNamed(context, ViewBankTransactionList.viewBankTransactionScreenID, arguments: bankName);
        }
        else{
          Navigator.pop(context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('${output['error']}')),
        );
      }
    } catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

}





// DropdownField(
//   label: 'Category',
//   value: selectedItem,
//   items: const ['General Expense', 'Business Expense'],
//   onChanged: (value) {
//     setState(() {
//       selectedItem = value;
//       selectedSubexpense = null; // Reset selected subexpense
//       selectedDepartmentExpense = null; // Reset selected department expense
//       selectedDepartmentSubcategory = null; // Reset selected department subcategory
//       showAdditionalField = false; // Reset additional field visibility
//       showEmployeeField = false; // Reset employee field visibility
//     });
//   },
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Please select an item';
//     }
//     return null;
//   },
// ),
// if (selectedItem != null)
//   Padding(
//     padding: const EdgeInsets.only(top: 15),
//     child: DropdownField(
//       label: selectedItem,
//       value: selectedSubexpense,
//       items: subexpenseOptions[selectedItem!] ?? [],
//       onChanged: (value) {
//         setState(() {
//           selectedSubexpense = value;
//           showAdditionalField = value == 'Everyday Expenses' || value == 'Department';
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a subexpense';
//         }
//         return null;
//       },
//     ),
//   ),
// if (showAdditionalField && selectedSubexpense != null)
//   Padding(
//     padding: const EdgeInsets.only(top: 15),
//     child: DropdownField(
//       label: selectedSubexpense!,
//       value: selectedDepartmentExpense,
//       items: departmentOptions[selectedSubexpense!] ?? [],
//       onChanged: (value) {
//         setState(() {
//           selectedDepartmentExpense = value;
//           selectedDepartmentSubcategory = null; // Reset selected department subcategory
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select an option';
//         }
//         return null;
//       },
//     ),
//   ),
// if (selectedDepartmentExpense != null)
//   Padding(
//     padding: const EdgeInsets.only(top: 15),
//     child: DropdownField(
//       label: selectedDepartmentExpense!,
//       value: selectedDepartmentSubcategory,
//       items: departmentSubcategoryOptions[selectedDepartmentExpense!]?.keys.toList() ?? [],
//       onChanged: (value) {
//         setState(() {
//           selectedDepartmentSubcategory = value;
//           selectedEmployeeOption = null; // Reset employee option
//           showEmployeeField = value == 'Department Salaries';
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a subcategory';
//         }
//         return null;
//       },
//     ),
//   ),
// if (selectedDepartmentSubcategory != null)
//   Padding(
//     padding: const EdgeInsets.only(top: 15),
//     child: DropdownField(
//       label: selectedDepartmentSubcategory!,
//       value: selectedEmployeeOption,
//       items: departmentSubcategoryOptions[selectedDepartmentExpense!]?[selectedDepartmentSubcategory!] ?? [],
//       onChanged: (value) {
//         setState(() {
//           selectedEmployeeOption = value;
//           // Add logic if additional field needs to be shown based on the selected value
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select an option';
//         }
//         return null;
//       },
//     ),
//   ),
// if (showEmployeeField && selectedEmployeeOption != null)
//   Padding(
//     padding: const EdgeInsets.only(top: 15),
//     child: InputField(
//       label: selectedEmployeeOption !, // Replace with the desired label
//       // value: null,
//       // items: ['Option 1', 'Option 2', 'Option 3'], // Add your specific options here
//       onChanged: (value) {
//         setState(() {
//           // Implement your onChanged logic here
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select an option';
//         }
//         return null;
//       },
//     ),
//   ),




// $query = "SELECT dp.id AS department_id, dp.dept_name, dp.status AS department_status, dp.company_id AS department_company_id, dpl.id AS purchasing_list_id, dpl.name, dpl.status AS purchasing_list_status, dpl.company_id AS purchasing_list_company_id FROM departments dp LEFT JOIN department_purchasing_list dpl ON dp.id = dpl.dpt_id WHERE `company_id`='$company_id'";