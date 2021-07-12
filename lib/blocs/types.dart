enum BlocTypes {
  CONTENT,
  FORM,
  LISTING
}

extension BlocTypeFactory on String {
  BlocTypes toBlocType() {
    switch(this) {
      case "listing":
        return BlocTypes.LISTING;
      case "form":
        return BlocTypes.FORM;
      default:
        return BlocTypes.CONTENT;
    }
  }
}