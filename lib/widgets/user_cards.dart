//TODO: fff

/* import 'dart:developer';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/search/cubit/search_cubit.dart';
import 'package:careme24/blocs/search/cubit/search_state.dart';
import 'package:careme24/widgets/med_card_widget/medical_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCards extends StatelessWidget {
  const UserCards({
    super.key,

    });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: size.width,
      height: size.height * 0.4,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: onCloseTap,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                !shareProfile ? 'Выберете у кого запросить профиль' :'Выберите кому передать профиль',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,  
                  color: Colors.white,  
                ),
                fillColor: Color.fromRGBO(221, 222, 226, 1),
                filled: true,
                hintText: 'Введите номер телефона',  
                hintStyle: TextStyle(color: Colors.white),  
                border: InputBorder.none,  
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), 
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), 
                ),
              ),
              style: TextStyle(color: Colors.black), 
              onChanged: (phoneNumber) {
                if (phoneNumber.isNotEmpty) {
                  AppBloc.searchCubit.fetchUsers(int.parse(phoneNumber));
                }
              },
            ),
            SizedBox(height: 12),

            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(state.users.length, (index) {
                          log('${state.users.length}');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MediacalCardWidget(
                              displayName: state.users[index].personalInfo.full_name,
                              phoneNumber: state.users[index].phone.toString(),
                              imagePath: state.users[index].personalInfo.avatar,
                              onTap: () {
                                onUserSelect(state.users[index]);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No results found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
 */
