class Price {
  final num left;
  final num rigth;

  Price({
    required this.left,
    required this.rigth,
  });

  Price.fromJson(List<dynamic> pricesData)
      : left = (pricesData.first as Map<String, dynamic>)['price'],
        rigth = (pricesData.last as Map<String, dynamic>)['price'];
}