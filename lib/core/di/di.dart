import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper.init();

  final sharedPreferencesHelper = SharedPreferencesHelper.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  // Register SharedPreferencesHelper
  getIt.registerLazySingleton<SharedPreferencesHelper>(
    () => sharedPreferencesHelper,
  );

  // Register FirebaseAuth
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  // Register FirebaseFirestore
  getIt.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);

  //Register FirebaseStorage
  getIt.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);

  // Chat
  getIt.registerLazySingleton(
    () => ChatLocalDataSource(sharedPreferencesHelper),
  );
  getIt.registerLazySingleton(() => ChatRemoteDataSource(firebaseFirestore));
  getIt.registerLazySingleton(
    () => ChatRepositoryImpl(
      remoteDataSource: getIt<ChatRemoteDataSource>(),
      localDataSource: getIt<ChatLocalDataSource>(),
    ),
  );
}
