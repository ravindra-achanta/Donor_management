

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vikas_app/bloc%20management/karyakarthas/karyakartha_event.dart';
// import 'package:vikas_app/bloc%20management/karyakarthas/karyakartha_state.dart';

// class KaryakarthasBloc
//     extends Bloc<KaryakarthasEvent, KaryakarthasState> {
//   final KaryakarthasRepository repository;

//   KaryakarthasBloc(this.repository)
//       : super(KaryakarthasInitial()) {

//     on<LoadKaryakarthas>((event, emit) async {
//       emit(KaryakarthasLoading());
//       final data = await repository.getAll();
//       emit(KaryakarthasLoaded(data));
//     });

//     on<AddKaryakartha>((event, emit) async {
//       await repository.add(event.karyakartha);
//       add(LoadKaryakarthas());
//     });

//     on<UpdateKaryakartha>((event, emit) async {
//       await repository.update(event.karyakartha);
//       add(LoadKaryakarthas());
//     });

//     on<DeleteKaryakartha>((event, emit) async {
//       await repository.delete(event.id);
//       add(LoadKaryakarthas());
//     });

//     on<ToggleKaryakarthaStatus>((event, emit) async {
//       await repository.toggleStatus(event.id, event.isActive);
//       add(LoadKaryakarthas());
//     });
//   }
// }
