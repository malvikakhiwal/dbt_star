Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test
- dbt clean && dbt deps && dbt build && dbt run

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


## Create virutal venv
rm -rf venv_dbt_star && virtualenv -p /Library/Frameworks/Python.framework/Versions/3.8/bin/python3.8 venv_dbt_star && source venv_dbt_star/bin/activate

pip install -r requirements.txt && dbt clean && dbt debug && dbt deps && pre-commit run --hook-stage manual sqlfluff-fix --all-files && pre-commit run --hook-stage manual sqlfluff-lint --all-files

### Run SQLFluff fix against all files
pre-commit run --hook-stage manual sqlfluff-fix --all-files 





## Installation and Usage

- Use the package manager [pip](https://pip.pypa.io/en/stable/) to install the dev requirements ([dbt](https://www.getdbt.com/), [pre-commit](https://pre-commit.com/))
- Run `pre-commit install` to set up your git hook scripts. This will set your hooks so that the next time you push, pre-commit will be invoked (note: on its first invocation, pre-commit will need to install its own dependencies which may take a minute; these dependencies will be installed outside of your project and will be available from that moment onwards).

```bash
$ pip install -r requirements.txt
$ pre-commit install
```
 

 ### Using the project:

Once everything has been setup, try running the following commands:

- dbt debug (if you're having issues)
- dbt deps
- dbt seed
- dbt run
- dbt test

dbt debug && dbt build


### SQL Styleguide + dbt Best Practices

We follow the [Matt Mazur SQL style guide](https://github.com/mattm/sql-style-guide) and the one by [dbt Labs for dbt-specific behaviors](https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md).

We also follow the [best practices documented on the dbt website](https://docs.getdbt.com/docs/guides/best-practices/).

SQL and YAML styles are enforced by linters that runs automatically before any commit.
 
&nbsp;

## Working with Pre-Commit
- Pre-commit is configured to run various checks automatically when you attempt to push your code. We've overridden the default commit pattern to run on push to make committing small changes easier. When you attempt to push your code the pre-commit hooks will run, and if they pass, the push will succeed; if not there is some sort of issue that needs to be resolved before pushing your changes.
- Pre-commit will only run against changed files to keep its execution as quick as possible.
- On its first execution, pre-commit will install any dependencies it needs into a virtual environment (located outside of this repo); this may take a few minutes on its first run, but every following run will reuse that env and as a result will be much quicker.
- The following tools are installed and orchestrated with pre-commit.
 

### Working with SQLFluff
- SQLFluff lint is configured as a pre-commit hook that runs on push, so in most cases no explicit commands are needed. This will only list errors and will not fix any errors if found.
- If you would like to run SQLFluff lint manually, or would like to run it in fix mode, you can do so with the following commands which will run them through pre-commit.
```
pre-commit run --hook-stage push sqlfluff-lint --all-files
pre-commit run --hook-stage manual sqlfluff-fix --all-files
```
 
