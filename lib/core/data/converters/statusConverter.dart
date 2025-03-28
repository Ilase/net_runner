String statusConverter(String status) {
  if (status == "working") {
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
