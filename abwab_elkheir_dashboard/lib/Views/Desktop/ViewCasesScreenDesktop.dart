import 'package:abwab_elkheir_dashboard/ViewModels/AuthenticationViewModel.dart';
import 'package:abwab_elkheir_dashboard/ViewModels/CasesViewModel.dart';
import 'package:abwab_elkheir_dashboard/Widgets/NavigationBarWidgets/Mobile/NavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/ConstantColors.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:vrouter/vrouter.dart';

class ViewCasesScreenDesktop extends StatefulWidget {
  final deviceSize;

  const ViewCasesScreenDesktop({Key key, this.deviceSize}) : super(key: key);
  @override
  _ViewCasesScreenDesktopState createState() => _ViewCasesScreenDesktopState();
}

class _ViewCasesScreenDesktopState extends State<ViewCasesScreenDesktop> {
  CasesViewModel viewModel;
  CasesViewModel listener;
  AuthenticationViewModel auth;
  ArabicNumbers arabicNumber = ArabicNumbers();
  bool isLoading = false;
  @override
  void initState() {
    auth = Provider.of<AuthenticationViewModel>(context, listen: false);
    viewModel = Provider.of<CasesViewModel>(context, listen: false);
    Future.microtask(
      () async {
        viewModel.fetchCases(context, auth.accessToken);
      },
    );
    super.initState();
  }

  void selectCase(BuildContext context, int id) {
    print(viewModel.cases[id].id);
    context.vRouter.push("/editCase/${viewModel.cases[id].id}");
  }

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final deviceSize = widget.deviceSize;
    listener = Provider.of<CasesViewModel>(context, listen: true);
    return Scaffold(
      key: _key,
      drawer: NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ConstantColors.lightBlue,
        onPressed: () {
          context.vRouter.push("/addCase");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(""),
        backgroundColor: ConstantColors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.filter_alt_rounded, color: Colors.white),
          onPressed: () {
            _key.currentState.openDrawer();
          },
        ),
      ),
      body: RefreshIndicator(
        color: ConstantColors.lightBlue,
        onRefresh: () async {
          await viewModel.fetchCases(context, auth.accessToken);
        },
        child: listener.status == Status.loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    ConstantColors.lightBlue,
                  ),
                ),
              )
            : listener.cases.isEmpty
                ? Center(
                    child: Text("لا يوجد حالات في الوقت الحالي"),
                  )
                : Container(
                    margin: EdgeInsets.only(top: deviceSize.height * 0.122),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: deviceSize.width / 2,
                            childAspectRatio: 7 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: listener.cases.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () => selectCase(ctx, index),
                            child: Container(
                              height: deviceSize.height * 0.22,
                              padding: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      child: Container(
                                          height: deviceSize.height * 0.27,
                                          width: deviceSize.width * 0.2,
                                          // padding: EdgeInsets.all(5),
                                          child: new FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/placeholder.png",
                                            image:
                                                listener.cases[index].images[0],
                                            fit: BoxFit.cover,
                                          )),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: deviceSize.width * 0.25,
                                          margin: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 20, right: 15),
                                          child: Text(
                                            listener.cases[index].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: ConstantColors.purple),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: Row(
                                              children: [
                                                Text('الحالة: ',
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                                Text(
                                                  '${viewModel.cases[index].status}',
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: viewModel
                                                                  .cases[index]
                                                                  .status ==
                                                              'في البداية'
                                                          ? Colors.red
                                                          : viewModel
                                                                      .cases[
                                                                          index]
                                                                      .status ==
                                                                  'جاري التجميع'
                                                              ? Colors.orange
                                                              : viewModel
                                                                          .cases[
                                                                              index]
                                                                          .status ==
                                                                      'قارب على الانتهاء'
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .green),
                                                ),
                                              ],
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: Text(
                                              'المبلغ: ${arabicNumber.convert(viewModel.cases[index].totalPrice)} جنيه',
                                              textAlign: TextAlign.right,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ))
                                        // FittedBox(
                                        //   child: Container(
                                        //     width: deviceSize.width * 0.25,
                                        //     child: Text(
                                        //       '${listener.cases[index].donations}/${listener.cases[index].totalPrice} جنيه',
                                        //       textAlign: TextAlign.left,
                                        //     ),
                                        //   ),
                                        // ),
                                        // Container(
                                        //   width: deviceSize.width * 0.25,
                                        //   height: 10,
                                        //   padding: EdgeInsets.only(right: 15),
                                        //   child: Stack(
                                        //     children: <Widget>[
                                        //       Container(
                                        //         decoration: BoxDecoration(
                                        //           border: Border.all(
                                        //               color: Colors.grey,
                                        //               width: 1.0),
                                        //           color: Color.fromRGBO(
                                        //               220, 220, 220, 1),
                                        //           borderRadius:
                                        //               BorderRadius.circular(10),
                                        //         ),
                                        //       ),
                                        //       FractionallySizedBox(
                                        //         widthFactor: listener
                                        //                 .cases[index]
                                        //                 .donations /
                                        //             listener.cases[index]
                                        //                 .totalPrice,
                                        //         child: Container(
                                        //           decoration: BoxDecoration(
                                        //             color:
                                        //                 ConstantColors.purple,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     10),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
      ),
    );
  }
}
