String statusConverter(String status) {
  if (status == "pending") {
    return "В процессе";
  }
  if (status == "error") {
    return "Ошибка";
  }
  if (status == "completed") {
    return "Завершено";
  }
  return "Неизвестен";
}
