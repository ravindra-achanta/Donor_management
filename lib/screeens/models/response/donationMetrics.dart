class ContributionResponse {
  final double totalContributions;
  final double monthlyAvgFrequency;
  final double monthlyAmountAvgFrequency;
  final List<DonationFrequency> donationFrequency;

  ContributionResponse({
    required this.totalContributions,
    required this.monthlyAvgFrequency,
    required this.monthlyAmountAvgFrequency,
    required this.donationFrequency,
  });

  factory ContributionResponse.fromJson(Map<String, dynamic> json) {
    return ContributionResponse(
      totalContributions: (json['totalContributions'] ?? 0).toDouble(),
      monthlyAvgFrequency: (json['monthlyAvgFrequency'] ?? 0).toDouble(),
      monthlyAmountAvgFrequency:
          (json['monthlyAmountAvgFrequency'] ?? 0).toDouble(),
      donationFrequency: (json['donationFrequency'] as List)
          .map((e) => DonationFrequency.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalContributions": totalContributions,
      "monthlyAvgFrequency": monthlyAvgFrequency,
      "monthlyAmountAvgFrequency": monthlyAmountAvgFrequency,
      "donationFrequency": donationFrequency.map((e) => e.toJson()).toList(),
    };
  }
}

class DonationFrequency {
  final double score;
  final double totalContributionInYear;
  final int year;
  final List<Donation> donations;

  DonationFrequency({
    required this.score,
    required this.totalContributionInYear,
    required this.year,
    required this.donations,
  });

  factory DonationFrequency.fromJson(Map<String, dynamic> json) {
    return DonationFrequency(
      score: (json['score'] ?? 0).toDouble(),
      totalContributionInYear:
          (json['totalContributionInYear'] ?? 0).toDouble(),
      year: json['year'] ?? 0,
      donations:
          (json['donatoins'] as List).map((e) => Donation.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "score": score,
      "totalContributionInYear": totalContributionInYear,
      "year": year,
      "donatoins": donations.map((e) => e.toJson()).toList(),
    };
  }
}

class Donation {
  final double amount;
  final DateTime date;

  Donation({
    required this.amount,
    required this.date,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "date": date.toIso8601String(),
    };
  }
}
