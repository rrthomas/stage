%% stage.cls
%% Copyright 2005 Robert Jahrling
%% Copyright 2017–2018 Reuben Thomas
%
% This is a LaTeX2e class called stage, providing a class
% for stage play Manuscript Format.
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2003/12/01 or later.
%
% This work has the LPPL maintenance status "maintained".
% 
% This Current Maintainer of this work is Reuben Thomas
%
% This work consists of the file stage.cls.
%
% See https://github.com/rrthomas/stage or contact me at rrt@sc3d.org
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stage}[2018/05/14 v1.01 Manuscript Format for stage plays]
% The class is based on the default book class
\LoadClass[12pt,oneside]{book}
\PassOptionsToClass{\CurrentOption}{book}
% We're going to use ifthen to do some conditional page breaking.
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage{extramarks}
\RequirePackage{needspace}
\RequirePackage{changepage}
% These three commands are required.
% The default font size is 12/14. It looks better than 12 solid.
% The textwidth and textheight represent one-inch margins all
% around.
\renewcommand{\normalsize}{\fontsize{12pt}{14pt}\selectfont}
\setlength{\textwidth}{6.0in}
\setlength{\textheight}{8.5in}
\setlength{\topmargin}{0in}

\raggedbottom


%%% Customizable strings (Note: keep in sync with the docs)
\newcommand{\actname}{Act}
\newcommand{\scenename}{Scene}
\newcommand{\continuedname}{Continued}
\newcommand{\castname}{Cast of Characters}
\newcommand{\theendname}{The End}

%%% pagestyle commands
% use fancy pagestyle
\pagestyle{fancy}
% Sets the left header to use the picture environment to put
% continued marks where necessary!
\lhead{\setlength{\unitlength}{\baselineskip}%
		\begin{picture}(0,0)
			\put(12.9,-1.1){\makebox(0,0)[tl]{\firstxmark}}
		\end{picture}\leftmark}
\rfoot{\lastxmark}
% puts the page numbers in the header on the right
\rhead{\thepage}
% empties center foot; otherwise, the page number would display here.
\cfoot{}
% by default, fancyhdr puts a rule in the header, which I don't want.
\renewcommand{\headrulewidth}{0pt}
% since we're using a slightly larger font, we need more headheight
\renewcommand{\headheight}{14pt}
%%%

% No indentation; space between paragraphs.
\usepackage{parskip}
% \introduce is used the first time we meet a character.
\newcommand{\introduce}[1]{\textsc{#1}}
% \address is used for the writer's address
\newcommand{\address}[1]{\gdef\@address{#1}}
% Counts acts
\newcounter{actcounter}
% We need to initialize actcounter for page numbering.
\setcounter{actcounter}{0}

% Counts scenes per act
\newcounter{scenecounter}[actcounter]
% \dialog sets the character's name above their speech
\let\stageoldep=\everypar
\newlength{\saveparskip}
\newcommand{\dialog}[2]{%
  \needspace{2\baselineskip}%
  {\begin{adjustwidth}{2.5in}{0in}\textsc{#1}\end{adjustwidth}\saveparskip=\parskip\parskip=0pt%
  \extramarks{}{}%
  {\begin{adjustwidth}{0in}{0in}\def\everypar{\parskip=\saveparskip\stageoldep}#2\end{adjustwidth}}%
  \extramarks{\textsc{#1} (\continuedname)}{}}
}

% \dialogue, for people who like that spelling better
\newcommand{\dialogue}[1]{\dialog{#1}}

% \act creates an act header, with large roman numerals
%
% Start a new page for each Act except the first
\newcommand{\act}{%
  \renewcommand{\thepage}{\Roman{actcounter}-\arabic{page}}%
  \ifthenelse{\value{actcounter} > 1}{\newpage}{\vspace{\parskip}}
  \stepcounter{actcounter}
  \hspace*{2.5in}\textsc{\actname} \Roman{actcounter}%
  \setcounter{page}{1}
}
% \scene creates a scene header, with arabic numerals
%
% Start a new page for each scene except the first
\newcommand{\scene}{%
  \extramarks{}{}%
  \stepcounter{scenecounter}
  \ifthenelse{\value{scenecounter} > 1}{\newpage}{\vspace{\parskip}}
  \hspace*{2.5in}\textsc{\scenename} \arabic{scenecounter}%
}
% \stage sets the stage directions farther in than the box
% containing the dialog, and parenthesizes them.
\newcommand{\stage}[1]{%
	\begin{adjustwidth}{2in}{0in}
		(#1)%
	\end{adjustwidth}
}
% \charsd is like \paren in ScriptTeX, used for brief character
% stage directions. It's intended to set properly into a passage
% of dialog.
\newcommand{\charsd}[1]{%
	{\def\everypar{\parskip=0pt\stageoldep}%
	\stage{#1}\par\leavevmode}}
% Undocumented, for backwards compatibility
\newcommand{\initsd}[1]{\charsd{#1}}

% \pause is just convenient.
\newcommand{\pause}{\stage{Pause.}}

% Implemented \paren to ease transition from ScriptTeX
\newcommand{\paren}[1]{\charsd{#1}}

% \opensd is opening stage directions, set differently from
% other stage directions; \opensd sets time and place.
\newcommand{\opensd}[1]{%
	\begin{adjustwidth}{2.5in}{0in}
		(#1)%
	\end{adjustwidth}
}
% \open is the same as \opensd
\newcommand{\open}[1]{\opensd{#1}}

% "placeholder" redefinition of \maketitle.
\renewcommand{\maketitle}{%
	\begin{titlepage}
		\center{\textsc{\@title}}
		\par
		\center{\@author}
		\vspace{5in}
		\begin{adjustwidth}{0in}{0in}
			\ifthenelse{\not\isundefined{\@address}}{\@address}{}
		\end{adjustwidth}
	\end{titlepage}
	\setcounter{page}{1}
}

% The castpage environment sets up the cast page
\newenvironment{castpage}{%
	\thispagestyle{empty}%
	\center{\textsc{\castname}}%
	\vspace{3ex}%
	\begin{adjustwidth}{0in}{0.5in}%
	}{%
	\end{adjustwidth}%
	\setcounter{page}{0}%
	\newpage%
}
% \addcharacter adds characters to the cast page.
\newcommand{\addcharacter}[2]{%
	\begin{tabular}[2]{p{2in} p{4in}}
		\textsc{#1} & #2\\[\parskip]
	\end{tabular}
}
% Mark the end of the document.
\AtEndDocument{%
		\hskip 2.5in %
		\textsc{\theendname}%
}
