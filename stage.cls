%% stage.cls
%% Copyright 2005 Robert Jahrling
%% Copyright 2017 Reuben Thomas
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
% CHANGES NEEDED 5/16/2003:
%   Fix Margins
%   Fix Widows/Orphans
%
% NOTES:
%	\castpage and \quotepage definitions must come after \maketitle
%		in any documents created with this class.
%	\act MUST appear or else page numbers get whacked. This should
%		be considered a TODO bugfix. Can be fixed by using \oneact.
%
% TODO:
%	Time/setting page
%	Character s.d. spacing is not the greatest.
%
% Required: 
%
% This is a LaTeX2e class called stage, providing a class
% for stage play Manuscript Format.
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stage}[2003/05/15 Manuscript Format for stage plays]
% The class is based on the default book class
\LoadClass[12pt,oneside,letterpaper]{book}
% We're going to use ifthen to do some conditional page breaking.
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage{extramarks}
% We provide a friendly warning when an option is specified;
% since stage provides no options, all options return an error.
% FIXME: Pass class options through to book
\DeclareOption*{%
	\ClassWarning{stage}{Unknown option `\CurrentOption'}%
}
% Required to process options.
\ProcessOptions\relax
% These three commands are required.
% The default font size is 12/14. It looks better than 12 solid.
% The textwidth and textheight represent one-inch margins all
% around.
\renewcommand{\normalsize}{\fontsize{12pt}{14pt}\selectfont}
\setlength{\textwidth}{6.0in}
\setlength{\textheight}{8.5in}
\setlength{\topmargin}{0in}

\raggedbottom

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

% No indentation. Double space between paragraphs.
\parindent 0pt
\parskip 0pt
\newlength{\doublespacelength}
\setlength{\doublespacelength}{1.6ex}
% \doublespace leaves a line's worth of space between elements.
\newcommand{\doublespace}{\vspace{\doublespacelength}}
% \introduce is used the first time we meet a character.
\newcommand{\introduce}[1]{\textsc{#1}}
% \address is used for the writer's copyright notice and address
\newcommand{\address}[1]{\gdef\@address{#1}}
% \draft is used if the writer wants to indicate draft number
\newcommand{\draft}[1]{\gdef\@draftno{#1}}
% \copyrightnotice is used if the writer wants to indicate copyright
\newcommand{\copyrightnotice}[1]{\gdef\@crightnotice{#1}}
% Counts acts
\newcounter{actcounter}
% We need to initialize actcounter for page numbering.
\setcounter{actcounter}{1}
% pagestyle and headers
% \thepage does page numbering.
%
% FIXME: this is incredibly ugly. For some reason, acts were not being
% numbered from 1, so I needed to initialize actcounter to 1.
% This had a side effect of making the use of actcounter in the
% headers off by 1, so we need to subtract 1 from the counter,
% print the page number, and add the 1 back in.
\renewcommand{\thepage}{%
		\addtocounter{actcounter}{-1}%
		\Roman{actcounter}-\arabic{page}%
		\addtocounter{actcounter}{1}%
}
% If we're writing a one-act play, we don't need the special page
% numbering scheme, so we tell stage that we're writing a one-act
% and it takes care of that.
\newcommand{\oneact}{%
		\renewcommand{\thepage}{%
			\arabic{page}%
		}%
}

% Counts scenes per act
\newcounter{scenecounter}[actcounter]
% An environment for specifying margin changes
\newenvironment{changemargin}[2]{%
	\begin{list}{}{%
		\setlength{\topsep}{0pt}%
		\setlength{\leftmargin}{#1}%
		\setlength{\rightmargin}{#2}%
		\setlength{\listparindent}{\parindent}%
		\setlength{\itemindent}{\parindent}%
		\setlength{\parsep}{\parskip}%
		}%
	\item[]}{\end{list}}
% \dialog sets the character's name above his speech
% FIXME: figure out how to keep name and speech together,
% i.e. not allow pagebreaks between name and speech.
\newcommand{\dialog}[2]{%
	\doublespace%
	\hskip 2.5in\textsc{#1}\par%
	\nobreak
	\extramarks{}{}
	\nobreak
	#2
	\extramarks{\textsc{#1} (Continued)}{}
}

% \dialogue, for people who like that spelling better
\newcommand{\dialogue}[1]{\dialog{#1}}

% \act creates an act header, with large roman numerals
%
% Start a new page for each Act except the first
\newcommand{\act}{%
	\begin{changemargin}{2.5in}{0in}
		\ifthenelse{\value{actcounter} > 1}{\newpage}{}
		\textsc{Act} \Roman{actcounter}
		\ifthenelse{\value{actcounter} = 1}{\doublespace}{}
		\stepcounter{actcounter}
	\end{changemargin}
	\setcounter{page}{1}
}
% \scene creates a scene header, with arabic numerals
%
% Start a new page for each scene except the first
\newcommand{\scene}{%
	\begin{changemargin}{2.5in}{0in}
		\stepcounter{scenecounter}
		\ifthenelse{\value{scenecounter} > 1}{\newpage}{}
		\textsc{Scene} \arabic{scenecounter}
		\ifthenelse{\value{scenecounter} = 1}{\doublespace}{}
	\end{changemargin}
}
% \stage sets the stage directions a little farther in than the
% dialog box and parenthesizes them.
%
% I'm not happy with this; I'd rather not have to put braces
% around the stage directions, but it seems like there's no
% way around it.
\newcommand{\stage}[1]{%
	\doublespace
	\begin{changemargin}{2in}{0in}
		(#1)%
	\end{changemargin}
}
% \charsd is like \paren in ScriptTeX, used for brief character
% stage directions. It's intended to set properly into a passage
% of dialog.
\newcommand{\charsd}[1]{%
	\begin{changemargin}{2in}{0in}
		(#1)%
	\end{changemargin}
}

% \pause is just convenient.
\newcommand{\pause}{\stage{Pause.}}

% \initsd is a quick hack to get around messed-up \charsd spacing
% when a \charsd comes before any dialog.
\newcommand{\initsd}[1]{%
	\vspace{-0.6ex}%
	\begin{changemargin}{2in}{0in}
		(#1)%
	\end{changemargin}
	\parskip 0pt
	\vspace{-0.6ex}
}

% Implemented \paren to ease transition from ScriptTeX
\newcommand{\paren}[1]{\charsd{#1}}

% \opensd is opening stage directions, set differently from
% other stage directions; \opensd sets time and place.
\newcommand{\opensd}[1]{%
	\begin{changemargin}{2.5in}{0in}
		(#1)%
	\end{changemargin}
}
% \open is the same as \opensd
\newcommand{\open}[1]{\opensd{#1}}

% "placeholder" redefinition of \maketitle.
%
% FIXME: address and copyright (copyright just gets folded in to address).
\renewcommand{\maketitle}{%
	\begin{titlepage}
		\center{\textsc{\@title}}
		\par
		\center{\@author}
		\vspace{5in}
		\begin{changemargin}{0in}{0in}
			\ifthenelse{\not\isundefined{\@crightnotice}}{%
				\copyright \@crightnotice}{}
			\par
			\ifthenelse{\not\isundefined{\@address}}{\@address}{}
			\par
			\ifthenelse{\not\isundefined{\@draftno}}{DRAFT \@draftno}{}
		\end{changemargin}
	\end{titlepage}
	\setcounter{page}{1}
}

\newcommand{\quotepage}[2]{%
	\thispagestyle{empty}
	\begin{quote}
	\end{quote}
	\begin{quote}
		\vspace{1in}
		``#1''\par\emph{#2}
	\end{quote}
	\setcounter{page}{0}
	\newpage
}
% The castpage environment sets up the cast page
\newenvironment{castpage}{%
	\thispagestyle{empty}%
	\center{\textsc{Cast of Characters}}%
	\vspace{3ex}%
	\begin{changemargin}{0in}{0.5in}%
	}{%
	\end{changemargin}%
	\setcounter{page}{0}%
	\newpage%
}
% \addcharacter adds characters to the cast page.
\newcommand{\addcharacter}[2]{%
	\begin{tabular}[2]{p{2in} p{4in}}
		\textsc{#1} & #2\\[\doublespacelength]
	\end{tabular}
}
% Print "The End" at the end of the document.
\AtEndDocument{%
		\doublespace %
		\hskip 2.5in %
		\textsc{The End}%
}
