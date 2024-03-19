# Welcome to the Pull Request Tutorial (Xplore)

This interactive tutorial will guide you through the process of making a pull request to contribute to this project. Follow the steps carefully and don't hesitate to ask for clarification if you encounter any issues.

## Getting Started

1. **Fork this repository** to your GitHub account by clicking the "Fork" button in the top-right corner of the repository page.

![Forking a Repository](https://i.imgur.com/G1NYhhx.png)

2. **Clone the forked repository** to your local machine:

```bash
git clone https://github.com/YOUR_USERNAME/Xplore.git
```

Replace `YOUR_USERNAME` with your actual GitHub username.

3. **Navigate to the project directory**:

```bash
cd Xplore
```

4. **Create a new branch** for your changes:

```bash
git checkout -b feature/your-feature-name
```

Replace `your-feature-name` with a descriptive name for your feature or change.
<hr>
🚨 **Potential Issue:** If you encounter an error saying `fatal: not a git repository`, it means you're not in the correct directory. Navigate to the `Xplore` directory and try again.
<hr>
## Making Changes

5. Make your desired changes to the codebase using your favorite code editor.

6. **Stage your changes**:

```bash
git add .
```

This command stages all the changes you've made.

7. **Commit your changes** with a descriptive message:

```bash
git commit -m "Add feature xyz"
```

Replace `"Add feature xyz"` with a concise description of your changes.
<hr>
🚨 **Potential Issue:** If you encounter an error saying `nothing added to commit but untracked files present`, it means you have new files that haven't been staged. Run `git add .` again and then commit your changes.
<hr>
## Pushing Changes

8. **Push your changes** to your forked repository:

```bash
git push origin feature/your-feature-name
```

Replace `your-feature-name` with the name of your branch.
<hr>
🚨 **Potential Issue:** If you encounter an error saying `remote origin already exists`, you may need to set the upstream repository by running:
<hr>
```bash
git remote add upstream https://github.com/SharanRP/Xplore.git
```

Then try pushing your changes again.

## Creating a Pull Request

9. Visit your forked repository on GitHub.
10. Switch to the branch you just pushed by clicking on the "Branch" dropdown and selecting your branch.

![Switching Branches](https://i.imgur.com/H2ibus6.png)

11. Click on the "New Pull Request" button.

![New Pull Request](https://i.imgur.com/r9fMowS.png)

12. Provide a descriptive title and description for your pull request, explaining the changes you've made and their purpose.

13. Click on the "Create Pull Request" button to submit your pull request.

![Create Pull Request](https://i.imgur.com/zfGZpPQ.png)

<hr>
🎉 Congratulations! You've successfully created a pull request. The project maintainers will review your changes and provide feedback or merge them into the main repository.
<hr>
## Adding Your Information

Please add your name and registration number below:

- Name: [Your Name]
- Registration Number: [Your Registration Number]

> **Note:** If you encounter any issues or have questions, feel free to ask for help in the project's discussion forum or reach out to the project maintainers.
