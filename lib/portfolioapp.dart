import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  ProfilePage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _resumeFile;

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PortfolioApp"),
      ),
      backgroundColor:
          widget.isDarkMode ? Colors.black : Color.fromARGB(255, 255, 209, 128),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Mohammad Al Faied',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Researcher, 4IR Research Cell\nDaffodil International University',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Professional Summary'),
              Text(
                'A student skilled in programming languages and ML algorithms. Teamwork experience and project management abilities. Fluent in English and Bengali languages. Eager to contribute to the wellbeing of the country',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 32),
              _buildSectionTitle('Education'),
              _buildEducationItem(
                'B.Sc. in Computer Science and Engineering',
                'Daffodil International University',
                'Graduation Year: 2024',
              ),
              _buildEducationItem(
                'H.S.C. in Science',
                'Mohammadpur Kendriya College, Dhaka',
                'Year: 2018 - 2020',
              ),
              _buildEducationItem(
                'S.S.C in Science',
                'Bangladesh Open University',
                'Year: 2016 - 2018',
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Skills'),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <String>[
                  'C',
                  'C++',
                  'Java',
                  'Python',
                  'HTML',
                  'CSS',
                  'Javascript',
                  'JSON',
                  'Shell Script',
                  'Machine Learning'
                      'CNN',
                  'Vision Transformer',
                  'Arduino',
                  'IoT',
                  'Dart',
                  'Flutter',
                  'Research',
                  'Data Analysis',
                ].map((skill) => Chip(label: Text(skill))).toList(),
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Experience'),
              ProjectCard(
                title: 'Researcher, 4IR Research Cell',
                description: '''Daffodil International University
2023 - Present
Writing research papers focused on Machine Learning, CNN, and ViT to drive innovation and technological advancement.''',
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Publications'),
              ProjectCard(
                title: 'Conferences',
                description:
                    '''* Crime Rate Prediction using Machine Learning: a Case Study of Bangladesh. (Ready to submit) ''',
              ),
              ProjectCard(
                title: 'Journals',
                description:
                    '''* Baccaurea Ramiflora Leaf Disease Detection using ViT. (Submitted to Q3)''',
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Resume/CV'),
              Center(
                child: ElevatedButton(
                  onPressed: _pickResume,
                  child: Text('Upload Resume/CV'),
                ),
              ),
              if (_resumeFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Uploaded: ${_resumeFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Social Media'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    color: Color.fromARGB(255, 65, 3, 236),
                    iconSize: 40,
                    onPressed: facebook_url,
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.github),
                    color: Color.fromARGB(255, 65, 3, 236),
                    iconSize: 40,
                    onPressed: github_url,
                  ),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.linkedin),
                      color: Color.fromARGB(255, 65, 3, 236),
                      iconSize: 43,
                      onPressed: linked_in_url),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram),
                      color: Color.fromARGB(255, 65, 3, 236),
                      iconSize: 43,
                      onPressed: instagram_url),
                ],
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 65, 3, 236)),
              SizedBox(height: 24),
              _buildSectionTitle('Blog'),
              Center(
                child: BlogSection(),
              ),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              SizedBox(height: 24),
              _buildSectionTitle('Achievements & Certifications'),
              ProjectCard(
                title: 'Competitions',
                description:
                    '''* Champion on Crack Dataset contest organized by DIU ML & NLP Lab.''',
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _pickResume,
                  child: Text('Upload Achievements/Certifications'),
                ),
              ),
              if (_resumeFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Uploaded: ${_resumeFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              SizedBox(height: 24),
              Divider(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 255, 0, 0)),
              _buildSectionTitle('Contact Information'),
              ListTile(
                leading: Icon(Icons.email),
                title: Row(
                  children: [
                    TextButton(
                      onPressed: () => launch('mailto:al15-4191@diu.edu.bd'),
                      child: Text('al15-4191@diu.edu.bd'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Row(
                  children: [
                    TextButton(
                      onPressed: () => launch('tel:+8801972416032'),
                      child: Text('+8801972416032'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.web),
                title: Row(
                  children: [
                    TextButton(
                      onPressed: () => launch(
                          'https://sites.google.com/diu.edu.bd/mohammadalfaied/home'),
                      child: Text(
                          'https://sites.google.com/diu.edu.bd/mohammadalfaied/home'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: widget.isDarkMode ? Colors.white : Colors.orangeAccent,
      ),
    );
  }

  Widget _buildEducationItem(String degree, String institution, String period) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school,
              color: widget.isDarkMode ? Colors.white : Colors.orangeAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  degree,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  institution,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
      String title, String company, String period, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.work,
              color: widget.isDarkMode ? Colors.white : Colors.orangeAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

linked_in_url() async {
  const url = 'https://www.linkedin.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

facebook_url() async {
  const url = 'https://web.facebook.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

github_url() async {
  const url = 'https://github.com/farabee76';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

instagram_url() async {
  const url = 'https://www.instagram.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  ProjectCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                //color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                  //color: widget.isDarkMode ? Colors.black : Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogSection extends StatefulWidget {
  @override
  _BlogSectionState createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  final List<Map<String, String>> _blogPosts = [];

  void _addBlogPost() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        return AlertDialog(
          title: Text('New Blog Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            Center(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _blogPosts.add({
                          'title': titleController.text,
                          'content': contentController.text,
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _addBlogPost,
          child: Text('Add Blog Post'),
        ),
        ..._blogPosts.map((post) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //color: widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    post['content']!,
                    style: TextStyle(
                        //color: widget.isDarkMode ? Colors.black : Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
