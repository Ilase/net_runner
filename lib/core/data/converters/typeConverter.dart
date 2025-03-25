String typeConverter(String type) {
  if (type == "networkscan") {
    return "Просмотр сети";
  }
  if (type == "pentest") {
    return "Пентест";
  }
  if (type == "agentInventory") {
    return "Инвенторизация (Агент)";
  }
  return "Неизвестен";
}
