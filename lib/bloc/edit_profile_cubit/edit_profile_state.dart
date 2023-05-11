part of 'edit_profile_cubit.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class ImageAddedState extends EditProfileState {}

class UpdateLoadingState extends EditProfileState {}

class UpdatedSuccessfullyState extends EditProfileState {}

class UpdatedFailedState extends EditProfileState {}

class GetingIndustriesSuccessfullyState extends EditProfileState {}

class GetingIndustriesFailedState extends EditProfileState {}

class GetingIndustriesLoadingState extends EditProfileState {}
