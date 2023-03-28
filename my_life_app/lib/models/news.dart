class News {
  final String? title;
  final String? description;
  final String? url;
  final String? categories;

  News(this.title, this.description, this.url, this.categories);
}

List<News> newslist = [
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Tai nạn giao thông kinh hoàn khiến 12 người thiệt mạng',
    'assets/images/tainan.jpg',
    'Tin tức Giao thông',
  ),
  News(
    'Tin tức giao thông ngày 22/3',
    '''
      Bạn đọc Báo Thanh Niên bày tỏ sự bức xúc với tình trạng xe chở hàng hóa cồng kềnh trên đường phố gây tai nạn nghiêm trọng cho người đi đường, yêu cầu cơ quan chức năng, nhất là CSGT, phải xử phạt quyết liệt hơn.
      Như Thanh Niên đưa tin, khoảng 16 giờ ngày 24.5, một nam thanh niên điều khiển xe máy chở theo bao tải hàng hóa cồng kềnh phía sau, chạy trên đường số 7, khu công nghiệp Vĩnh Lộc, P.Bình Hưng Hòa B, Q.Bình Tân (TP.HCM) hướng ra QL1. Khi qua giao lộ đường số 7 - đường số 2 khoảng 50 m, bao tải hàng hóa trên xe của nam thanh niên va vào tay lái xe máy của người phụ nữ (42 tuổi, quê Quảng Trị), lưu thông cùng chiều, khiến người phụ nữ ngã ra đường và bị chính xe máy của mình đè lên người. Nạn nhân được đưa vào một phòng khám đa khoa cấp cứu trong tình trạng đa chấn thương, gãy lìa xương chân. Phòng khám sau đó phải chuyển gấp nạn nhân lên tuyến trên để tiếp tục điều trị.
      Đừng vì mưu sinh gây họa cho người khác
      Trước tình trạng xe chở hàng cồng kềnh nhiều lần gây họa, bạn đọc (BĐ) Binh Vo Thai bày tỏ quan điểm: “Tôi gặp rất nhiều trường hợp chở hàng cồng kềnh, đa phần thiếu ý thức, phóng nhanh, lạng lách. Đừng ngụy biện vì mưu sinh, đây là vấn đề ý thức”. Cùng quan điểm, BĐ Luc Hoang viết: “Sợ nhất xe ba gác chở tôn chở sắt giống như những con dao bay trên đường phố. Đừng có đổ cho cái nghèo mà bất chấp luật pháp, coi thường tính mạng người khác”.
      “Rất nhiều xe máy chở hàng cồng kềnh chiếm không gian dù xe 2 bánh chỉ được chở người. Rất nhiều xe ba gác chở sắt tôn ló dài nguy hiểm cho người dân đi đường mà chẳng thấy ai phạt...”, BĐ ở địa chỉ do***@gmail.com “tố”. Nhiều BĐ cũng cho rằng việc xử phạt xe chở hàng cồng kềnh, nhất là xe thô sơ, hình như chưa được thường xuyên, lâu lâu có chuyên đề CSGT mới quyết liệt, sau đó lại có phần “lơ là” nên tình trạng này tồn tại gây bức xúc. “Đặc sản riêng của giao thông Việt Nam rồi. Chẳng lẽ không có cách nào trị được?”, BĐ Phieuphan ta thán.
      Đề xuất phạt cả chủ hàng
      Nhiều BĐ đề nghị cơ quan chức năng, nhất là CSGT phải vào cuộc thật quyết liệt, phạt nặng những trường hợp chở hàng hóa cồng kềnh gây nguy hiểm cho người khác. “Nên xử lý phạt nặng, tịch thu các loại xe chở cồng kềnh gây tai nạn cho người đi đường mới răn đe được”, BĐ Quý Phùng nêu. Trong khi đó, BĐ Đức Huỳnh Quang cho rằng: “Xe chở hàng cồng kềnh, quá khổ là vi phạm luật giao thông đường bộ, lại còn gây tai nạn, nên cần phạt nặng để làm gương”.
      Đáng chú ý, một số BĐ cho rằng không chỉ người chở hàng có lỗi mà chủ thuê chở hàng cũng phải chịu trách nhiệm. Theo BĐ Nam Doan: “Tôi nhận thấy không chỉ có trách nhiệm của người chở hàng, mà đồng thời người chủ hàng cũng phải liên đới chịu trách nhiệm”. Tương tự, BĐ Quang Hải Phù bày tỏ: “Nên xử phạt cả người chở hàng cồng kềnh lẫn chủ hàng vì lợi nhuận mà khiến người khác chở hàng cồng kềnh để giảm chi phí”.
      
    ''',
    'assets/images/tainan1.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức giao thông đường bộ mới nhất hôm nay',
    'Đoạn tuyến đường đi vũng tàu Đồng Nai có nhiều nơi xuất hiện các ổ gà ổ voi khiến cho giao thông khu vực này thường xuyên xảy ra tai nạn gây nên sự bất an cho người dân nơi đây',
    'assets/images/duonghu1.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Hiện tượng ùn tắc giao thông thường xuyên xảy ra trên tuyến đường Lê Văn Việt đi ngã tư Thủ Đức',
    'assets/images/ketxe.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức lũ lụt mới nhất hôm nay',
    'Lũ lụt xuất hiện nhiều nơi trên toàn quốc',
    'assets/images/lulut.jpg',
    'Tin lũ lụt',
  ),
  News(
    'Đồng hành cùng đồng bào Miền Trung',
    'Với việc mưa liên tục trong nhiều ngày qua thì Miền Trung sắp đón nhận trận lũ lụt lớn nhất lịch sử',
    'assets/images/lulutmientrung.jpg',
    'Tin lũ lụt',
  ),
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Trên tuyến đường Võ Văn Ngân đi chợ Thủ Đức thường xuyên bị ngập ún mỗi khi mưa lớn kéo dài',
    'assets/images/ngaplut.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Đường hư',
    'assets/images/duonghu1.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Đường hư 2',
    'assets/images/duonghu2.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức lũ lụt mới nhất hôm nay',
    'Lũ lụt xuất hiện nhiều nơi trên toàn quốc',
    'assets/images/lulut.jpg',
    'Tin lũ lụt',
  ),
  News(
    'Tin tức giao thông mới nhất hôm nay',
    'Tai nạn giao thông kinh hoàn khiến 12 người thiệt mạng',
    'assets/images/tainan.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức lũ lụt mới nhất hôm nay',
    'Lũ lụt xuất hiện nhiều nơi trên toàn quốc',
    'assets/images/lulut.jpg',
    'Tin lũ lụt',
  ),
  News(
    'Tin tức giao thông đường bộ mới nhất hôm nay',
    'Đoạn tuyến đường đi vũng tàu Đồng Nai có nhiều nơi xuất hiện các ổ gà ổ voi khiến cho giao thông khu vực này thường xuyên xảy ra tai nạn gây nên sự bất an cho người dân nơi đây',
    'assets/images/duonghu1.jpg',
    'Tin tức giao thông',
  ),
  News(
    'Tin tức giao thông đường bộ mới nhất hôm nay',
    'Đoạn tuyến đường đi vũng tàu Đồng Nai có nhiều nơi xuất hiện các ổ gà ổ voi khiến cho giao thông khu vực này thường xuyên xảy ra tai nạn gây nên sự bất an cho người dân nơi đây',
    'assets/images/duonghu1.jpg',
    'Tin tức giao thông',
  ),
];
