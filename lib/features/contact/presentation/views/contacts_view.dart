import 'package:chat_app/core/asset_names.dart';
import 'package:chat_app/core/router/app_routes.dart';
import 'package:chat_app/core/widgets/asset_image_widget.dart';
import 'package:chat_app/core/widgets/search_bar.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactsView extends StatelessWidget {
  ContactsView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'contacts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
        actions: [
          const SizedBox.shrink(),
          IconButton(
            onPressed: () {},
            icon: const AssetImageWidget(
              assetPath: addContact,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16,
        ),
        child: Column(
          children: [
            CustomSearchBar(
              controller: searchController,
              hintText: 'search_for_a_contact'.tr(),
            ),
            Expanded(
              child: BlocConsumer<ContactBloc, ContactState>(
                builder: (context, state) {
                  if (state is ContactLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContactLoaded) {
                    return ListView.builder(
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      contact.photoUrl ?? '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(contact.name),
                              subtitle: Text(contact.phone),
                              onTap: () {
                                context.read<ContactBloc>().add(
                                      NavigateToChatScreenEvent(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        contactId: contact.id,
                                        contacts: state.contacts,
                                      ),
                                    );
                              },
                            ),
                            const Divider(
                              color: Color(0xFFEDEDED),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is ContactError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
                listener: (BuildContext context, ContactState state) {
                  if (state is NavigatingToChatScreen) {
                    context.goNamed(
                      AppRoute.chat.name,
                      queryParameters: {
                        'chatId': state.conversationId,
                        'receiverId': state.receieverId,
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
