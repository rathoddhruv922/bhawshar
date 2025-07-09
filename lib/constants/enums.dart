enum AppLanguage { en, hi, ma }

enum ConnectionType { wifi, mobile }

enum CityStatus { initial, loading, loaded, failure }

enum ClientSettingStatus { initial, loading, loaded, failure }

enum StateStatus { initial, loading, loaded, failure }

enum ProductStatus { initial, loading, loaded, failure }

enum AreaStatus { initial, loading, loaded, failure }

enum ReportStatus { initial, loading, loaded, failure }

enum AuthStateStatus {
  loading,
  sendingMail,
  confirmingOtp,
  sended,
  confirmed,
  authenticated,
  unAuthenticated,
  updating,
  updated,
  failure
}

enum ExpenseStatus {
  initial,
  loading,
  load,
  loaded,
  adding,
  added,
  deleting,
  deleted,
  updating,
  updated,
  failure
}

enum ExpenseByIdStatus { initial, loading, loaded, failure }

enum ExpenseCommentStatus { initial, adding, added, failure }

enum CommentStatus {
  initial,
  loading,
  load,
  loaded,
  adding,
  added,
  deleting,
  deleted,
  updating,
  updated,
  failure
}

enum FeedbackStatus {
  initial,
  loading,
  load,
  loaded,
  adding,
  added,
  deleting,
  deleted,
  updating,
  updated,
  closing,
  closed,
  failure
}

enum ReminderStatus {
  initial,
  loading,
  loaded,
  load,
  adding,
  added,
  deleting,
  deleted,
  completing,
  completed,
  updating,
  updated,
  failure
}

enum MedicalStatus {
  initial,
  loading,
  loaded,
  adding,
  added,
  updating,
  updated,
  failure
}

enum OrderStatus {
  initial,
  loading,
  loaded,
  load,
  adding,
  cancelling,
  cancelled,
  added,
  deleting,
  deleted,
  updating,
  updated,
  failure
}
