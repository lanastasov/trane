# language: bg
Функционалност: Регистрация на потребители
  За да правим връзка между конкретни студенти и домашните им
  като преподавателски екип
  искаме всеки студент да има регистрация в сайта

  Сценарий: Регистриране на записан студент
    Дадено че има записан студент
    Когато отида на страницата за регистрация
    И попълня данните на регистрирания студент
    И натисна "Регистрирай ме"
    И проследя активационната връзка в полученото писмо
    И въведа парола
    То трябва да съм успешно влязъл в системата
