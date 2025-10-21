import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // For Future.delayed

void main() {
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (BuildContext context) => AppState(),
      builder: (BuildContext context, Widget? child) => const BairroConectadoApp(),
    ),
  );
}

class BairroConectadoApp extends StatelessWidget {
  const BairroConectadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bairro Conectado',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, // Using a direct color as theme context might not be available
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[200],
          labelStyle: const TextStyle(color: Colors.black87),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue, // Using a direct color as theme context might not be available
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomeScreen(),
        '/polls': (BuildContext context) => const PollsScreen(),
        '/forum': (BuildContext context) => const ForumScreen(),
        '/new-topic': (BuildContext context) => const NewTopicScreen(),
        '/new-poll': (BuildContext context) => const NewPollScreen(),
        '/success': (BuildContext context) => const SuccessScreen(),
        '/confirmation': (BuildContext context) => const ConfirmationScreen(),
        '/details': (BuildContext context) => const DetailsScreen(),
        '/location': (BuildContext context) => const LocationScreen(),
        '/category': (BuildContext context) => const CategoryScreen(),
        '/tracking': (BuildContext context) => const TrackingScreen(),
      },
    );
  }
}

class FeedPost {
  final int id;
  final String type;
  final String title;
  final String content;
  final String time;
  final String category;
  final int? votes;

  const FeedPost({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.time,
    required this.category,
    this.votes,
  });
}

class ForumTopic {
  final int id;
  final String title;
  final String author;
  final int replies;
  final int likes;
  final String time;
  final String category;
  final String content;
  final bool isHot;

  const ForumTopic({
    required this.id,
    required this.title,
    required this.author,
    required this.replies,
    required this.likes,
    required this.time,
    required this.category,
    required this.content,
    required this.isHot,
  });
}

class PollOption {
  final String id;
  final String text;
  final int votes;
  final int percentage;

  const PollOption({
    required this.id,
    required this.text,
    required this.votes,
    required this.percentage,
  });
}

class PollData {
  final int id;
  final String title;
  final String description;
  final List<PollOption> options;
  final int totalVotes;
  final String timeLeft;
  final String status;
  final bool userVoted;
  final String? userChoice;

  const PollData({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.totalVotes,
    required this.timeLeft,
    required this.status,
    required this.userVoted,
    this.userChoice,
  });
}

class Category {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color borderColor;

  const Category({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.borderColor,
  });
}

class ReportStep {
  final String title;
  final String description;
  String status; // 'pending', 'current', 'completed'

  ReportStep({required this.title, required this.description, this.status = 'pending'});
}

class ReportData {
  final String id; // Protocol number
  final String categoryTitle;
  final IconData categoryIcon;
  final String location;
  final String description;
  final String? photoUrl;
  final String submissionTime;
  List<ReportStep> steps;
  String overallStatus; // 'received', 'in_analysis', 'in_progress', 'completed'

  ReportData({
    required this.id,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.location,
    required this.description,
    this.photoUrl,
    required this.submissionTime,
    required this.steps,
    this.overallStatus = 'received',
  });
}

class AppState extends ChangeNotifier {
  String selectedCategory = '';
  String location = '';
  String description = '';
  String attachedPhoto = '';
  String forumSearchQuery = '';

  String newTopicTitle = '';
  String newTopicContent = '';
  String newTopicCategory = '';

  String _newPollTitle = '';
  List<String> _newPollOptions = <String>['', '']; // Start with two empty options
  bool _isPublishingPoll = false;

  String get newPollTitle => _newPollTitle;
  List<String> get newPollOptions => _newPollOptions;
  bool get isPublishingPoll => _isPublishingPoll;

  String? selectedPoll;
  bool isLoadingLocation = false;

  ReportData? _currentReport;
  ReportData? get currentReport => _currentReport;

  void setSelectedCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setAttachedPhoto(String value) {
    attachedPhoto = value;
    notifyListeners();
  }

  void setForumSearchQuery(String value) {
    forumSearchQuery = value;
    notifyListeners();
  }

  void setNewTopicTitle(String value) {
    newTopicTitle = value;
    notifyListeners();
  }

  void setNewTopicContent(String value) {
    newTopicContent = value;
    notifyListeners();
  }

  void setNewTopicCategory(String value) {
    newTopicCategory = value;
    notifyListeners();
  }

  void setNewPollTitle(String value) {
    _newPollTitle = value;
    notifyListeners();
  }

  void addPollOption() {
    if (_newPollOptions.length < 5) {
      _newPollOptions.add('');
      notifyListeners();
    }
  }

  void updatePollOption(int index, String value) {
    if (index >= 0 && index < _newPollOptions.length) {
      _newPollOptions[index] = value;
      notifyListeners();
    }
  }

  void removePollOption(int index) {
    if (_newPollOptions.length > 2 && index >= 0 && index < _newPollOptions.length) {
      _newPollOptions.removeAt(index);
      notifyListeners();
    }
  }

  void setIsLoadingPublishingPoll(bool value) {
    _isPublishingPoll = value;
    notifyListeners();
  }

  void setSelectedPoll(String? value) {
    selectedPoll = value;
    notifyListeners();
  }

  void setIsLoadingLocation(bool value) {
    isLoadingLocation = value;
    notifyListeners();
  }

  void resetReportForm() {
    selectedCategory = '';
    location = '';
    description = '';
    attachedPhoto = '';
    _currentReport = null; // Clear current report
    notifyListeners();
  }

  void resetNewTopicForm() {
    newTopicTitle = '';
    newTopicContent = '';
    newTopicCategory = '';
    notifyListeners();
  }

  void resetNewPollForm() {
    _newPollTitle = '';
    _newPollOptions = <String>['', ''];
    _isPublishingPoll = false;
    notifyListeners();
  }

  void submitReport({
    required String categoryId,
    required String location,
    required String description,
    String? photoUrl,
    required List<Category> allCategories,
  }) {
    final String protocolNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    final Category selectedCategory = allCategories.firstWhere((Category c) => c.id == categoryId);

    final List<ReportStep> initialSteps = <ReportStep>[
      ReportStep(title: 'Chamado Recebido', description: 'Seu chamado foi registrado com o protocolo #$protocolNumber.'),
      ReportStep(title: 'Análise Inicial', description: 'A equipe responsável analisará a solicitação em até 2 dias úteis.'),
      ReportStep(title: 'Em Andamento', description: 'Se aprovado, o problema será resolvido em até 5 dias úteis.'),
      ReportStep(title: 'Concluído', description: 'Você será notificado sobre a conclusão do chamado.'),
    ];

    initialSteps[0].status = 'completed';
    if (initialSteps.length > 1) {
      initialSteps[1].status = 'current';
    }

    _currentReport = ReportData(
      id: protocolNumber,
      categoryTitle: selectedCategory.title,
      categoryIcon: selectedCategory.icon,
      location: location,
      description: description,
      photoUrl: photoUrl,
      submissionTime: 'agora',
      steps: initialSteps,
      overallStatus: 'in_analysis',
    );
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<FeedPost> feedPosts = const <FeedPost>[
    FeedPost(
      id: 1,
      type: 'news',
      title: 'Nova iluminação instalada na Rua das Flores',
      content:
          'A Prefeitura concluiu a instalação de 15 novos postes de LED na Rua das Flores, melhorando a segurança dos moradores.',
      time: '2h atrás',
      category: 'Iluminação',
    ),
    FeedPost(
      id: 2,
      type: 'poll',
      title: 'Qual a prioridade para o próximo mês?',
      content:
          'Vote na principal necessidade do bairro para os próximos investimentos da Prefeitura.',
      time: '4h atrás',
      category: 'Enquete',
      votes: 127,
    ),
    FeedPost(
      id: 3,
      type: 'news',
      title: 'Buraco na Av. Principal foi reparado',
      content:
          'Graças ao chamado #847, o buraco na Avenida Principal foi reparado pela equipe de manutenção.',
      time: '1 dia atrás',
      category: 'Vias Públicas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text('Bairro Conectado'),
          ],
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Bem-vindo ao seu bairro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Acompanhe as novidades e participe das decisões da sua comunidade',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: feedPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  final FeedPost post = feedPosts[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Chip(
                                label: Text(post.category),
                                backgroundColor:
                                    post.type == 'poll' ? Colors.blue[100] : Colors.grey[200],
                                labelStyle: TextStyle(
                                    color: post.type == 'poll' ? Colors.blue[800] : Colors.black87),
                              ),
                              Text(
                                post.time,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.content,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (post.type == 'poll') ...<Widget>[
                            const SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.bar_chart, size: 16),
                                const SizedBox(width: 4),
                                Text('${post.votes} votos',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/polls');
                                },
                                icon: const Icon(Icons.how_to_vote),
                                label: const Text('VOTAR'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AppState>(context, listen: false).resetReportForm();
          Navigator.pushNamed(context, '/category');
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.campaign),
            Text('Reportar', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/forum');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/polls');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Fórum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Enquetes',
          ),
        ],
      ),
    );
  }
}

class PollsScreen extends StatelessWidget {
  const PollsScreen({super.key});

  final List<PollData> pollsData = const <PollData>[
    PollData(
      id: 1,
      title: 'Qual deve ser a prioridade de investimento para 2025?',
      description:
          'Vote na área que você considera mais importante para receber investimentos da Prefeitura no próximo ano.',
      options: <PollOption>[
        PollOption(
            id: 'a', text: 'Melhorias na iluminação pública', votes: 45, percentage: 35),
        PollOption(id: 'b', text: 'Reparo de ruas e calçadas', votes: 52, percentage: 40),
        PollOption(id: 'c', text: 'Mais áreas de lazer e praças', votes: 20, percentage: 15),
        PollOption(id: 'd', text: 'Segurança pública', votes: 13, percentage: 10),
      ],
      totalVotes: 130,
      timeLeft: '5 dias',
      status: 'active',
      userVoted: false,
    ),
    PollData(
      id: 2,
      title: 'Horário preferido para eventos comunitários',
      description:
          'Ajude-nos a escolher o melhor horário para realizar eventos no bairro.',
      options: <PollOption>[
        PollOption(id: 'a', text: 'Manhã (8h às 12h)', votes: 25, percentage: 30),
        PollOption(id: 'b', text: 'Tarde (14h às 18h)', votes: 35, percentage: 42),
        PollOption(id: 'c', text: 'Noite (19h às 22h)', votes: 23, percentage: 28),
      ],
      totalVotes: 83,
      timeLeft: '2 dias',
      status: 'active',
      userVoted: true,
      userChoice: 'b',
    ),
    PollData(
      id: 3,
      title: 'Aprovação do novo projeto de ciclovia',
      description:
          'O que você acha da proposta de construir uma ciclovia na Avenida Principal?',
      options: <PollOption>[
        PollOption(id: 'a', text: 'Aprovo totalmente', votes: 67, percentage: 55),
        PollOption(id: 'b', text: 'Aprovo com ressalvas', votes: 30, percentage: 25),
        PollOption(id: 'c', text: 'Não aprovo', votes: 24, percentage: 20),
      ],
      totalVotes: 121,
      timeLeft: 'Encerrada',
      status: 'closed',
      userVoted: true,
      userChoice: 'a',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bar_chart, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text('Enquetes'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Participe das Decisões',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sua opinião é importante para o desenvolvimento do bairro',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text(
                            'Enquetes Ativas',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                                '${pollsData.where((PollData p) => p.status == 'active').length} ativas'),
                            backgroundColor: Colors.green[100],
                            labelStyle: TextStyle(color: Colors.green[800]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...pollsData.where((PollData poll) => poll.status == 'active').map<Widget>((PollData poll) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        poll.title,
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Chip(
                                      label: Row(
                                        children: <Widget>[
                                          const Icon(Icons.access_time, size: 12),
                                          const SizedBox(width: 4),
                                          Text(poll.timeLeft),
                                        ],
                                      ),
                                      backgroundColor: Colors.blue[100],
                                      labelStyle: TextStyle(color: Colors.blue[800]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  poll.description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                ...poll.options.map<Widget>((PollOption option) {
                                  final bool isSelected =
                                      poll.userVoted && poll.userChoice == option.id;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isSelected ? Colors.blue[600] : Colors.grey[200],
                                        foregroundColor: isSelected ? Colors.white : Colors.black87,
                                        padding: const EdgeInsets.all(16),
                                        alignment: Alignment.centerLeft,
                                        elevation: isSelected ? 4 : 1,
                                      ),
                                      onPressed: poll.userVoted
                                          ? null
                                          : () {
                                              appState.setSelectedPoll('${poll.id}-${option.id}');
                                              debugPrint('Voted for option ${option.id} in poll ${poll.id}');
                                            },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(option.text,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w500))),
                                              Text('${option.percentage}%',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected ? Colors.white : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          LinearProgressIndicator(
                                            value: option.percentage / 100,
                                            backgroundColor: Colors.grey[300],
                                            color:
                                                isSelected ? Colors.blue[200] : Colors.grey[600],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('${option.votes} votos',
                                                  style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.grey[700])),
                                              if (isSelected)
                                                const Icon(Icons.check_circle,
                                                    size: 16, color: Colors.white),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(Icons.people, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${poll.totalVotes} participantes'),
                                      ],
                                    ),
                                    if (poll.userVoted)
                                      const Chip(
                                        label: Text('Você já votou'),
                                        backgroundColor: Colors.grey,
                                        labelStyle: TextStyle(color: Colors.white),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          const Text(
                            'Enquetes Encerradas',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                                '${pollsData.where((PollData p) => p.status == 'closed').length} encerradas'),
                            backgroundColor: Colors.grey[300],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...pollsData.where((PollData poll) => poll.status == 'closed').map<Widget>((PollData poll) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Opacity(
                            opacity: 0.75,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          poll.title,
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Chip(
                                        label: Text('Encerrada'),
                                        backgroundColor: Colors.grey,
                                        labelStyle: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    poll.description,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  ...poll.options.map<Widget>((PollOption option) {
                                    final int maxPercentage = poll.options
                                        .map<int>((PollOption o) => o.percentage)
                                        .reduce((int a, int b) => a > b ? a : b);
                                    final bool isWinner = option.percentage == maxPercentage;
                                    final bool isUserChoice = poll.userChoice == option.id;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isWinner
                                                  ? Colors.green[200]!
                                                  : Colors.grey[300]!),
                                          color: isWinner
                                              ? Colors.green[50]
                                              : Colors.grey[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    option.text +
                                                        (isUserChoice ? ' (seu voto)' : ''),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isWinner
                                                          ? Colors.green[800]
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '${option.percentage}%',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: isWinner
                                                            ? Colors.green[800]
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    if (isWinner)
                                                      const Icon(Icons.trending_up,
                                                          size: 16,
                                                          color: Colors.green),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            LinearProgressIndicator(
                                              value: option.percentage / 100,
                                              backgroundColor: Colors.grey[300],
                                              color: isWinner
                                                  ? Colors.green[500]
                                                  : Colors.grey[600],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${option.votes} votos',
                                              style: const TextStyle(
                                                  fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const Divider(),
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.people, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${poll.totalVotes} participantes'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Provider.of<AppState>(context, listen: false).resetNewPollForm();
          Navigator.pushNamed(context, '/new-poll');
        },
        label: const Text('Criar Enquete'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/forum');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Fórum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Enquetes',
          ),
        ],
      ),
    );
  }
}

class NewPollScreen extends StatelessWidget {
  const NewPollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Criar Nova Enquete'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          final bool canPublish = appState.newPollTitle.length >= 10 &&
              appState.newPollOptions.length >= 2 &&
              appState.newPollOptions.every((String option) => option.trim().length >= 3);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Defina o título e as opções para sua nova enquete.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: appState.newPollTitle),
                  decoration: InputDecoration(
                    labelText: 'Título da Enquete *',
                    hintText: 'Ex: Qual a prioridade para o próximo mês?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (String value) {
                    appState.setNewPollTitle(value);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Mínimo de 10 caracteres (${appState.newPollTitle.length}/10)',
                  style: TextStyle(
                      color: appState.newPollTitle.length < 10 ? Colors.red : Colors.grey,
                      fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Opções da Enquete * (Mínimo 2, máximo 5)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...appState.newPollOptions.asMap().entries.map<Widget>((MapEntry<int, String> entry) {
                  final int index = entry.key;
                  final String optionText = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: optionText),
                            decoration: InputDecoration(
                              labelText: 'Opção ${index + 1}',
                              hintText: 'Ex: Melhorias na iluminação pública',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorText: optionText.trim().length < 3 && optionText.isNotEmpty
                                  ? 'Mínimo 3 caracteres'
                                  : null,
                            ),
                            onChanged: (String value) {
                              appState.updatePollOption(index, value);
                            },
                          ),
                        ),
                        if (appState.newPollOptions.length > 2)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: appState.isPublishingPoll
                                ? null
                                : () {
                                    appState.removePollOption(index);
                                  },
                          ),
                      ],
                    ),
                  );
                }).toList(),
                if (appState.newPollOptions.length < 5)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: appState.isPublishingPoll
                        ? null
                        : () {
                            appState.addPollOption();
                          },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Adicionar Opção'),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.isPublishingPoll || !canPublish
                      ? null
                      : () async {
                          appState.setIsLoadingPublishingPoll(true);
                          await Future<void>.delayed(const Duration(seconds: 2));
                          debugPrint('Nova enquete publicada: ${appState.newPollTitle}');
                          for (final String option in appState.newPollOptions) {
                            debugPrint(' - $option');
                          }
                          appState.resetNewPollForm();
                          appState.setIsLoadingPublishingPoll(false);
                          Navigator.pop(context);
                        },
                  child: appState.isPublishingPoll
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.publish),
                            SizedBox(width: 8),
                            Text('Publicar Enquete'),
                          ],
                        ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.isPublishingPoll
                      ? null
                      : () {
                          appState.resetNewPollForm();
                          Navigator.pop(context);
                        },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  final List<ForumTopic> forumTopics = const <ForumTopic>[
    ForumTopic(
      id: 1,
      title: 'Proposta para nova praça no centro do bairro',
      author: 'Maria Silva',
      replies: 23,
      likes: 45,
      time: '3h atrás',
      category: 'Infraestrutura',
      content:
          'Gostaria de propor a criação de uma nova praça no terreno vazio da Rua Central. Seria um ótimo espaço para as famílias se reunirem.',
      isHot: true,
    ),
    ForumTopic(
      id: 2,
      title: 'Horários de coleta de lixo - mudanças necessárias',
      author: 'João Santos',
      replies: 12,
      likes: 28,
      time: '5h atrás',
      category: 'Serviços',
      content:
          'Os horários atuais de coleta não estão funcionando bem para nossa rua. Vamos discutir alternativas?',
      isHot: false,
    ),
    ForumTopic(
      id: 3,
      title: 'Grupo de caminhada matinal - quem se anima?',
      author: 'Ana Costa',
      replies: 8,
      likes: 15,
      time: '1 dia atrás',
      category: 'Comunidade',
      content:
          'Estou organizando um grupo para caminhadas matinais no parque. Interessados, comentem aqui!',
      isHot: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.message, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text('Fórum'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Provider.of<AppState>(context, listen: false).resetNewTopicForm();
              Navigator.pushNamed(context, '/new-topic');
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          final List<ForumTopic> filteredTopics = forumTopics.where((ForumTopic topic) {
            return appState.forumSearchQuery.isEmpty ||
                topic.title
                    .toLowerCase()
                    .contains(appState.forumSearchQuery.toLowerCase()) ||
                topic.content
                    .toLowerCase()
                    .contains(appState.forumSearchQuery.toLowerCase()) ||
                topic.author
                    .toLowerCase()
                    .contains(appState.forumSearchQuery.toLowerCase()) ||
                topic.category
                    .toLowerCase()
                    .contains(appState.forumSearchQuery.toLowerCase());
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Discussões da Comunidade',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Participe das conversas e compartilhe suas ideias',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar discussões...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (String value) {
                    appState.setForumSearchQuery(value);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTopics.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ForumTopic topic = filteredTopics[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.message, color: Colors.blue),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  topic.title,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (topic.isHot) ...<Widget>[
                                                const SizedBox(width: 8),
                                                Chip(
                                                  label: const Text('🔥 Popular'),
                                                  backgroundColor: Colors.red[600],
                                                  labelStyle: const TextStyle(
                                                      color: Colors.white, fontSize: 10),
                                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Chip(label: Text(topic.category)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      topic.content,
                                      style: const TextStyle(color: Colors.grey),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text('Por ${topic.author}'),
                                            const SizedBox(width: 16),
                                            Text(topic.time),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Icon(Icons.thumb_up, size: 16),
                                            const SizedBox(width: 4),
                                            Text('${topic.likes}'),
                                            const SizedBox(width: 16),
                                            const Icon(Icons.message, size: 16),
                                            const SizedBox(width: 4),
                                            Text('${topic.replies}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                          ),
                          onPressed: () {
                            appState.resetNewTopicForm();
                            Navigator.pushNamed(context, '/new-topic');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add),
                              SizedBox(width: 8),
                              Text('Iniciar Nova Discussão'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Compartilhe suas ideias e propostas com a comunidade',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/polls');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Fórum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Enquetes',
          ),
        ],
      ),
    );
  }
}

class NewTopicScreen extends StatelessWidget {
  const NewTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/forum');
          },
        ),
        title: const Text('Nova Discussão'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Inicie uma nova discussão para engajar a comunidade',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: appState.newTopicTitle),
                  decoration: InputDecoration(
                    labelText: 'Título da Discussão *',
                    hintText: 'Ex: Proposta para melhorar a iluminação da praça',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (String value) {
                    appState.setNewTopicTitle(value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: appState.newTopicContent),
                  decoration: InputDecoration(
                    labelText: 'Conteúdo da Discussão *',
                    hintText:
                        'Descreva sua proposta, pergunta ou ideia com detalhes...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (String value) {
                    appState.setNewTopicContent(value);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Mínimo de 50 caracteres (${appState.newTopicContent.length}/50)',
                  style: TextStyle(
                      color: appState.newTopicContent.length < 50 ? Colors.red : Colors.grey,
                      fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categoria *',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <String>['Infraestrutura', 'Serviços', 'Comunidade'].map<Widget>((String cat) {
                    return ChoiceChip(
                      label: Text(cat),
                      selected: appState.newTopicCategory == cat,
                      onSelected: (bool selected) {
                        if (selected) {
                          appState.setNewTopicCategory(cat);
                        } else {
                          appState.setNewTopicCategory('');
                        }
                      },
                      selectedColor: Colors.blue[100],
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                          color: appState.newTopicCategory == cat ? Colors.blue[800] : Colors.black87),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Dicas para uma boa discussão',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Seja claro e específico no título\n'
                                '• Forneça contexto e detalhes no conteúdo\n'
                                '• Mantenha o respeito e a cordialidade',
                                style: TextStyle(color: Colors.blue[800]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.newTopicTitle.length < 10 ||
                          appState.newTopicContent.length < 50 ||
                          appState.newTopicCategory.isEmpty
                      ? null
                      : () {
                          debugPrint('Nova discussão: ${appState.newTopicTitle}, '
                              '${appState.newTopicContent}, ${appState.newTopicCategory}');
                          appState.resetNewTopicForm();
                          Navigator.pushNamed(context, '/forum');
                        },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text('Publicar Discussão'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/forum');
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  Widget _buildStep(String number, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        final ReportData? report = appState.currentReport;
        final String protocolNumber = report?.id ?? 'N/A'; // Use dynamic protocol

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 32),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, size: 48, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chamado Recebido!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'O protocolo #$protocolNumber agora está em análise pela Prefeitura.',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Chip(
                                label: Text('#$protocolNumber'),
                                backgroundColor: Colors.green,
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Número do Protocolo',
                            style:
                                TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                          ),
                          const Text(
                            'Guarde este número para acompanhar o andamento',
                            style: TextStyle(color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Próximos Passos',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildStep(
                            '1',
                            'Análise Inicial',
                            'Sua solicitação será analisada pela equipe responsável em até 2 dias úteis',
                            Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          _buildStep(
                            '2',
                            'Execução',
                            'Se aprovado, o problema será resolvido em até 5 dias úteis',
                            Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          _buildStep(
                            '3',
                            'Notificação',
                            'Você será notificado sobre o status e conclusão do chamado',
                            Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tracking');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('Acompanhar Status'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).resetReportForm();
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 8),
                        Text('Voltar ao Feed'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey[50],
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Dúvidas? Entre em contato pelo telefone 156 ou pelo email atendimento@prefeitura.gov.br',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  final List<Category> categories = const <Category>[
    Category(
      id: 'lighting',
      title: 'Iluminação',
      description: 'Postes queimados, falta de luz',
      icon: Icons.lightbulb_outline,
      color: Colors.yellow,
      textColor: Colors.amber,
      borderColor: Colors.yellowAccent,
    ),
    Category(
      id: 'road',
      title: 'Buraco na Rua',
      description: 'Buracos, asfalto danificado',
      icon: Icons.traffic,
      color: Colors.orange,
      textColor: Colors.orange,
      borderColor: Colors.orangeAccent,
    ),
    Category(
      id: 'trash',
      title: 'Acúmulo de Lixo',
      description: 'Lixo acumulado, coleta atrasada',
      icon: Icons.delete_outline,
      color: Colors.green,
      textColor: Colors.green,
      borderColor: Colors.greenAccent,
    ),
    Category(
      id: 'security',
      title: 'Segurança',
      description: 'Problemas de segurança pública',
      icon: Icons.security,
      color: Colors.red,
      textColor: Colors.red,
      borderColor: Colors.redAccent,
    ),
    Category(
      id: 'water',
      title: 'Vazamento de Água',
      description: 'Vazamentos, falta de água',
      icon: Icons.water_drop_outlined,
      color: Colors.blue,
      textColor: Colors.blue,
      borderColor: Colors.blueAccent,
    ),
    Category(
      id: 'vegetation',
      title: 'Vegetação Alta',
      description: 'Matagal, árvores caídas',
      icon: Icons.forest,
      color: Colors.brown,
      textColor: Colors.brown,
      borderColor: Colors.brown,
    ),
    Category(
      id: 'animals',
      title: 'Animais Abandonados',
      description: 'Animais de rua, maus-tratos',
      icon: Icons.pets,
      color: Colors.pink,
      textColor: Colors.pink,
      borderColor: Colors.pinkAccent,
    ),
  ];

  Widget _buildSummaryRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/details');
          },
        ),
        title: const Text('Revisar e Enviar'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          final Category selectedCategoryData =
              categories.firstWhere((Category c) => c.id == appState.selectedCategory, orElse: () => categories[0]);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Revise as informações do seu chamado antes de enviar',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.campaign, size: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Resumo do Chamado',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          icon: selectedCategoryData.icon,
                          title: 'Categoria',
                          value: selectedCategoryData.title,
                          onEdit: () {
                            Navigator.pushNamed(context, '/category');
                          },
                        ),
                        _buildSummaryRow(
                          icon: Icons.location_on,
                          title: 'Localização',
                          value: appState.location.isEmpty ? 'Não informada' : appState.location,
                          onEdit: () {
                            Navigator.pushNamed(context, '/location');
                          },
                        ),
                        _buildSummaryRow(
                          icon: Icons.message,
                          title: 'Descrição',
                          value: appState.description.isEmpty ? 'Não informada' : appState.description,
                          onEdit: () {
                            Navigator.pushNamed(context, '/details');
                          },
                        ),
                        _buildSummaryRow(
                          icon: Icons.camera_alt,
                          title: 'Foto',
                          value: appState.attachedPhoto.isEmpty
                              ? 'Nenhuma foto anexada'
                              : 'Anexada: ${appState.attachedPhoto}',
                          onEdit: () {
                            Navigator.pushNamed(context, '/details');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Importante',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, color: Colors.blue),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Após o envio, você receberá um número de protocolo para acompanhar o amndamento do seu chamado. A Prefeitura tem até 5 dias úteis para responder.',
                                style: TextStyle(color: Colors.blue[800]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    appState.submitReport(
                      categoryId: appState.selectedCategory,
                      location: appState.location,
                      description: appState.description,
                      photoUrl: appState.attachedPhoto.isNotEmpty ? appState.attachedPhoto : null,
                      allCategories: categories,
                    );
                    Navigator.pushNamed(context, '/success');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text('Enviar Chamado Agora'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/details');
                  },
                  child: const Text('Voltar e Corrigir'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Cancelar Processo'),
                          content: const Text(
                              'Você tem certeza que deseja cancelar o processo de reporte? Todas as informações serão perdidas.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                appState.resetReportForm();
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text('Sim', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Cancelar Processo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  final List<Category> categories = const <Category>[
    Category(
      id: 'lighting',
      title: 'Iluminação',
      description: 'Postes queimados, falta de luz',
      icon: Icons.lightbulb_outline,
      color: Colors.yellow,
      textColor: Colors.amber,
      borderColor: Colors.yellowAccent,
    ),
    Category(
      id: 'road',
      title: 'Buraco na Rua',
      description: 'Buracos, asfalto danificado',
      icon: Icons.traffic,
      color: Colors.orange,
      textColor: Colors.orange,
      borderColor: Colors.orangeAccent,
    ),
    Category(
      id: 'trash',
      title: 'Acúmulo de Lixo',
      description: 'Lixo acumulado, coleta atrasada',
      icon: Icons.delete_outline,
      color: Colors.green,
      textColor: Colors.green,
      borderColor: Colors.greenAccent,
    ),
    Category(
      id: 'security',
      title: 'Segurança',
      description: 'Problemas de segurança pública',
      icon: Icons.security,
      color: Colors.red,
      textColor: Colors.red,
      borderColor: Colors.redAccent,
    ),
    Category(
      id: 'water',
      title: 'Vazamento de Água',
      description: 'Vazamentos, falta de água',
      icon: Icons.water_drop_outlined,
      color: Colors.blue,
      textColor: Colors.blue,
      borderColor: Colors.blueAccent,
    ),
    Category(
      id: 'vegetation',
      title: 'Vegetação Alta',
      description: 'Matagal, árvores caídas',
      icon: Icons.forest,
      color: Colors.brown,
      textColor: Colors.brown,
      borderColor: Colors.brown,
    ),
    Category(
      id: 'animals',
      title: 'Animais Abandonados',
      description: 'Animais de rua, maus-tratos',
      icon: Icons.pets,
      color: Colors.pink,
      textColor: Colors.pink,
      borderColor: Colors.pinkAccent,
    ),
  ];

  void handlePhotoAttachment(AppState appState) {
    appState.setAttachedPhoto('foto_problema.jpg');
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/location');
          },
        ),
        title: const Text('Detalhe o chamado'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          final String selectedCategoryTitle = appState.selectedCategory.isEmpty
              ? 'Não selecionada'
              : categories
                  .firstWhere((Category c) => c.id == appState.selectedCategory)
                  .title;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Descreva o problema com detalhes para ajudar a equipe responsável',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: appState.description),
                  decoration: InputDecoration(
                    labelText: 'Descrição do problema *',
                    hintText:
                        'Descreva o problema com o máximo de detalhes possível...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (String value) {
                    appState.setDescription(value);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Mínimo de 20 caracteres (${appState.description.length}/20)',
                  style: TextStyle(
                      color: appState.description.length < 20 ? Colors.red : Colors.grey,
                      fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Anexar Foto (Opcional)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                if (appState.attachedPhoto.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.green),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  appState.attachedPhoto,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green),
                                ),
                                const Text(
                                  'Foto anexada com sucesso',
                                  style: TextStyle(color: Colors.green, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              appState.setAttachedPhoto('');
                            },
                            child: const Text('Remover', style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    onPressed: () => handlePhotoAttachment(appState),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8),
                        Text('Anexar Foto do Problema'),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Uma foto ajuda a equipe a entender melhor o problema',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Resumo do Chamado',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryItem(
                          'Categoria',
                          selectedCategoryTitle,
                        ),
                        _buildSummaryItem(
                          'Local',
                          appState.location.isEmpty ? 'Não informado' : appState.location,
                        ),
                        _buildSummaryItem(
                          'Foto',
                          appState.attachedPhoto.isEmpty ? 'Não anexada' : 'Anexada',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.description.length < 20
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/confirmation');
                        },
                  child: const Text('Revisar Chamado'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Cancelar Processo'),
                          content: const Text(
                              'Você tem certeza que deseja cancelar o processo de reporte? Todas as informações serão perdidas.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                appState.resetReportForm();
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text('Sim', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Cancelar Processo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  Future<void> handleUseCurrentLocation(AppState appState) async {
    appState.setIsLoadingLocation(true);
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      appState.setLocation('Localização atual (Exemplo de Lat: -23.5505, Long: -46.6333)');
    } catch (e) {
      appState.setLocation('Erro ao obter localização');
      debugPrint('Erro ao obter localização: $e');
    } finally {
      appState.setIsLoadingLocation(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/category');
          },
        ),
        title: const Text('Onde é o problema?'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Informe o endereço ou ponto de referência do problema',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: appState.location),
                  decoration: InputDecoration(
                    labelText: 'Endereço ou Ponto de Referência',
                    hintText: 'Ex: Rua das Flores, 123 ou próximo ao mercado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (String value) {
                    appState.setLocation(value);
                  },
                ),
                const SizedBox(height: 16),
                const Text('ou', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.isLoadingLocation
                      ? null
                      : () => handleUseCurrentLocation(appState),
                  child: appState.isLoadingLocation
                      ? const CircularProgressIndicator()
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.navigation),
                            SizedBox(width: 8),
                            Text('Usar minha localização atual (GPS)'),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Visualização no Mapa',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.location_on, size: 48, color: Colors.grey),
                        const Text('Mapa será exibido aqui'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Localização: ${appState.location.isEmpty ? 'Não informada' : appState.location}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: appState.location.trim().isEmpty || appState.isLoadingLocation
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/details');
                        },
                  child: const Text('Próximo'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Cancelar Processo'),
                          content: const Text(
                              'Você tem certeza que deseja cancelar o processo de reporte? Todas as informações serão perdidas.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                appState.resetReportForm();
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text('Sim', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Cancelar Processo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Category> categories = const <Category>[
    Category(
      id: 'lighting',
      title: 'Iluminação',
      description: 'Postes queimados, falta de luz',
      icon: Icons.lightbulb_outline,
      color: Colors.yellow,
      textColor: Colors.amber,
      borderColor: Colors.yellowAccent,
    ),
    Category(
      id: 'road',
      title: 'Buraco na Rua',
      description: 'Buracos, asfalto danificado',
      icon: Icons.traffic,
      color: Colors.orange,
      textColor: Colors.orange,
      borderColor: Colors.orangeAccent,
    ),
    Category(
      id: 'trash',
      title: 'Acúmulo de Lixo',
      description: 'Lixo acumulado, coleta atrasada',
      icon: Icons.delete_outline,
      color: Colors.green,
      textColor: Colors.green,
      borderColor: Colors.greenAccent,
    ),
    Category(
      id: 'security',
      title: 'Segurança',
      description: 'Problemas de segurança pública',
      icon: Icons.security,
      color: Colors.red,
      textColor: Colors.red,
      borderColor: Colors.redAccent,
    ),
    Category(
      id: 'water',
      title: 'Vazamento de Água',
      description: 'Vazamentos, falta de água',
      icon: Icons.water_drop_outlined,
      color: Colors.blue,
      textColor: Colors.blue,
      borderColor: Colors.blueAccent,
    ),
    Category(
      id: 'vegetation',
      title: 'Vegetação Alta',
      description: 'Matagal, árvores caídas',
      icon: Icons.forest,
      color: Colors.brown,
      textColor: Colors.brown,
      borderColor: Colors.brown,
    ),
    Category(
      id: 'animals',
      title: 'Animais Abandonados',
      description: 'Animais de rua, maus-tratos',
      icon: Icons.pets,
      color: Colors.pink,
      textColor: Colors.pink,
      borderColor: Colors.pinkAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: const Text('O que está acontecendo?'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Selecione o tipo de problema que você quer reportar',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Category category = categories[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: appState.selectedCategory == category.id
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: appState.selectedCategory == category.id ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            appState.setSelectedCategory(category.id);
                            Navigator.pushNamed(context, '/location');
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: category.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(category.icon, color: category.textColor),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        category.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        category.description,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                if (appState.selectedCategory == category.id)
                                  Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                                else
                                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Cancelar Processo'),
                          content: const Text(
                              'Você tem certeza que deseja cancelar o processo de reporte? Todas as informações serão perdidas.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                appState.resetReportForm();
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text('Sim', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Cancelar Processo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  Widget _buildStepTile({
    required BuildContext context,
    required ReportStep step,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final bool isCompleted = step.status == 'completed';
    final bool isCurrent = step.status == 'current';
    final Color lineColor = isCompleted || isCurrent ? Theme.of(context).primaryColor : Colors.grey[400]!;
    final Color circleColor = isCompleted ? Colors.green : (isCurrent ? Theme.of(context).primaryColor : Colors.grey[400]!);
    final IconData icon = isCompleted ? Icons.check : (isCurrent ? Icons.circle : Icons.radio_button_off);
    final Color iconColor = isCompleted ? Colors.white : (isCurrent ? Colors.white : Colors.grey[600]!);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: lineColor,
                ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: lineColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: isFirst ? 0 : 4, bottom: isLast ? 0 : 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted || isCurrent ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: TextStyle(
                      color: isCompleted || isCurrent ? Colors.grey[700] : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              overflow: isLongText ? TextOverflow.ellipsis : TextOverflow.clip,
              maxLines: isLongText ? 3 : 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Acompanhar Chamado'),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          final ReportData? report = appState.currentReport;

          if (report == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.info_outline, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum chamado recente para acompanhar.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Envie um novo chamado para ver o status aqui.',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        appState.resetReportForm();
                        Navigator.pushNamedAndRemoveUntil(context, '/category', (Route<dynamic> route) => false);
                      },
                      child: const Text('Fazer um novo chamado'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Status do seu protocolo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Acompanhe o andamento do seu chamado #${report.id} em tempo real.',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.campaign, size: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Detalhes do Chamado',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                            icon: report.categoryIcon,
                            label: 'Categoria',
                            value: report.categoryTitle),
                        _buildDetailRow(
                            icon: Icons.location_on,
                            label: 'Localização',
                            value: report.location),
                        _buildDetailRow(
                            icon: Icons.description,
                            label: 'Descrição',
                            value: report.description,
                            isLongText: true),
                        if (report.photoUrl != null && report.photoUrl!.isNotEmpty)
                          _buildDetailRow(
                              icon: Icons.camera_alt,
                              label: 'Foto Anexada',
                              value: report.photoUrl!),
                        _buildDetailRow(
                            icon: Icons.access_time,
                            label: 'Data de Envio',
                            value: 'Protocolado ${report.submissionTime}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.timeline, size: 16, color: Colors.green),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Progresso do Chamado',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: report.steps.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildStepTile(
                              context: context,
                              step: report.steps[index],
                              isFirst: index == 0,
                              isLast: index == report.steps.length - 1,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.home),
                      SizedBox(width: 8),
                      Text('Voltar à Página Inicial'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
