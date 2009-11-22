% University of Tampere Thesis style
% based on
% University of Washington Thesis class
% by Jim Fox
% LaTeX2e version 1995
% from the latex209 thesis.sty, 1990,1991
 
%
% This is version 4
%
% Documentation is in the companion document (uwthesis.tex)
%

\ProvidesClass{utathesis}[1997/10/17]
\NeedsTeXFormat{LaTeX2e}

%
% footnote stuff for option processing
%

\newwrite\tf@not

\newif\ifendnotes      % true if doing endnotes
  \endnotesfalse
\newif\ifchapternotes  % true if doing chapternotes
  \chapternotesfalse
\let\printchapternotes\relax
\let\printendnotes\relax
 
\DeclareOption{footnotes}% selects bottom-of-page notes (default)
  {}
\DeclareOption{chapternotes}% selects end-of-chapter notes
  {\chapternotestrue}
\DeclareOption{endnotes}% selects end-of-thesis notes
  {\endnotestrue}

%
% ----  Thesis is a modified 12-pt book style  ----------------------------
%

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\PassOptionsToClass{12pt}{book}
\PassOptionsToClass{openany}{book}
\ProcessOptions
\LoadClass{book}

%
% margins are approximately 1 inch, except 1.5 inch at the binding
%

\textheight 225mm \textwidth 145mm
\marginparwidth 0.80in
\if@twoside
\oddsidemargin  0.40in
\evensidemargin 0.40in
\else
\oddsidemargin  0.40in
\evensidemargin 0.40in
\fi
\marginparsep 7\p@
\topmargin 0\p@   \headheight 12\p@ \headsep 36\p@
\footskip 12\p@
\footnotesep=14\p@
\setlength\parindent{1.5em}

\def\baselinestretch{1.2}
\setcounter{totalnumber}{5}
\setcounter{topnumber}{5}
\renewcommand\topfraction{.7}
\renewcommand\textfraction{.2}
\setlength\floatsep    {18\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\textfloatsep{30\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep   {20\p@ \@plus 4\p@ \@minus 4\p@}

 
%
%  ----  Footnotes  -----------------------
%
% Footnote placement option
%
%   [endnotes] put the references at the thesis end
%   [chapternotes] put the references at the chapter end
%   [footnotes] put the references at the page bottom
%
%   When text is written to file (.not) the source linebreaks
%   are maintained.  This keeps the individual lines in the file short.
%   Control sequences in the note text are not expanded.
%

\let\n@teitem\relax

\def\@chapternotetext{\begingroup
  \catcode`\^^M=12\newlinechar=`\^^M
  \catcode`\\=12
  \d@chapternote}

\long\def\d@chapternote#1{%
  \immediate \write\tf@not
      {\n@teitem[\note@label] #1\relax}%
  \endgroup}

%
\def\@startnotes{%  opens the .not file
  \immediate \openout\tf@not\jobname.not\relax
  \immediate \write\tf@not{\relax}
  \setcounter{footnote}{0}}

%
% chapternotes
%

\ifchapternotes
  % \typeout{Doing chapternotes}
  \let\@footnotetext\@chapternotetext
  \@startnotes
  \def\note@label{\arabic{footnote}}
  \def\printchapternotes{% Prints the accumulated notes
    \ifnum\c@footnote>1
      \clearpage
      \begin{center} Viitteet lukuun \arabic{chapter} \end{center}\par
      \addcontentsline{toc}{section}{\protect
          \numberline{}{Viitteet lukuun \arabic{chapter}}}
      \begin{description}
      \immediate\closeout\tf@not
      \catcode`@=11
      \let\n@teitem\item
      \@input{\jobname.not}
      \end{description}
      \clearpage
      \@startnotes
    \fi
  }
  \let\old@enddocument\enddocument
  \def\enddocument{\label{end-of-document}%
\printchapternotes\old@enddocument}
\fi

%
% endnotes
%

\ifendnotes
  % \typeout{Doing endnotes}
  \let\@footnotetext\@chapternotetext
  \@startnotes
  \def\note@label{\arabic{chapter}.\arabic{footnote}}
  \def\printendnotes{% Prints the accumulated notes
    \chapter*{Notes}
    \addcontentsline{toc}{chapter}{Notes}
    \thispagestyle{plain}
    \begin{description}
    \immediate\closeout\tf@not
    \catcode`@=11
    \let\n@teitem\item
    \@input{\jobname.not}
    \end{description}
    \@startnotes  % allows multiple endnotes
   }
\fi

%
%  bottom-of-page footnotes format
%  full width line and hanging indent
%
\def\footnoterule{\kern-3\p@
 \hrule width \columnwidth \kern 2.6\p@}
\long\def\@makefntext#1{\parindent 1em\noindent \hangindent\parindent
 \def\baselinestretch{1.0}
 \hbox to1em{\hss$^{\@thefnmark}\,$}#1}
 
%
%  ----  Text pages  ----------------------------------
%
%  In two-sided style Chapter 1 is right handed
%
\def\textofChapter#1{\gdef\@textofChapter{#1}}  \textofChapter{}
\def\textofAppendix#1{\gdef\@textofAppendix{#1}}  \textofAppendix{Liite}

\def\textpages{% Start of text pages
   \clearpage\pagestyle{empty}
   \cleardoublepage\pagestyle{myheadings}\markboth{}{}
   \def\@chapapp{\protect\@textofChapter}
   \def\Thechapter{\arabic{chapter}}
   \pagenumbering{arabic}
   \textheight 225mm  % allow for no footers (vers 1.3)
     \footskip 0pt
   % \ifarchitect \textwidth 145mm \oddsidemargin 36pt \twocolumn\fi
   }
 
\def\appendix{\par
 \setcounter{chapter}{0}
 \setcounter{section}{0}
 \def\@chapapp{\protect\@textofAppendix}
 \def\Thechapter{\Alph{chapter}}
 \def\thechapter{\Alph{chapter}}}
 
 
%
%  Chapter headings
%
\def\@makechapterhead#1{{%\centering
  \hskip -\parskip
\ifnum \c@secnumdepth>\m@ne\large\Thechapter.%
 \vspace{10pt}\fi\large\bf\uppercase\expandafter{#1}\par
 \hskip -\parskip
 \nobreak}}
%
\def\@makeschapterhead#1{\vspace*{2pc}{\centering
 \large\bf \uppercase\expandafter{#1}\par
 \nobreak \vspace{20pt}} }
%
\def\chapter{%
   \printchapternotes
   \if@openright\cleardoublepage\else\clearpage\fi
   \thispagestyle{empty}%
   \global\@topnum\z@
   \@afterindenttrue
   \let\\\relax
%   \secdef\@chapter\@schapter}
  \@startsection{chapter}{0}{\z@}%
       {-3.25ex\@plus -1ex \@minus -.2ex}%
       {1.5ex \@plus .2ex}%
       {\reset@font\Large\bfseries\scshape}}

%
%  Complication is added here to allow line breaks
%  in the chapter titles (via \\).
%
\def\@chapter[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
  \refstepcounter{chapter}
  \typeout{<<\thechapter>>}
  {\def\\{ }  % allow \\ in title
   \addcontentsline{toc}{chapter}{\protect
     \numberline{\thechapter}#1}}\else
  {\def\\{ }  % allow \\ in title
   \addcontentsline{toc}{chapter}{#1}}\fi
 \addtocontents{lof}{\protect\addvspace{10pt}}
 \addtocontents{lot}{\protect\addvspace{10pt}}
 \if@twocolumn
  \@topnewpage[\@makechapterhead{#2}]
  \else \@makechapterhead{#2}
  \@afterheading \fi}
\def\@schapter#1{\if@twocolumn \@topnewpage[\@makeschapterhead{#1}]
  \else \@makeschapterhead{#1}
 \@afterheading\fi}



%  Section headings
%
\renewcommand\section{%
  \@startsection {section}{1}{\z@}%
       {-3.5ex \@plus -1ex \@minus -.2ex}%
       {2.3ex \@plus.2ex}%
       {\reset@font\normalsize\bfseries}}
\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}%
       {-3.25ex\@plus -1ex \@minus -.2ex}%
       {1.5ex \@plus .2ex}%
       {\reset@font\normalsize\mdseries}}
\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}%
       {-3.25ex\@plus -1ex \@minus -.2ex}%
       {1.5ex \@plus .2ex}%
       {\reset@font\normalsize\mdseries}}

%
%  Provide for `Chapter ' in the toc
%  (increase \@tempdima)
%
%\renewcommand\l@chapter[2]{%
%  \ifnum \c@tocdepth >\m@ne
%    \addpenalty{-\@highpenalty}%
%    \vskip 1.0em \@plus\p@
%    \setlength\@tempdima{85pt}%
%    \begingroup
%      \parindent \z@ \rightskip \@pnumwidth
%      \parfillskip -\@pnumwidth
%      \leavevmode \bfseries
%      \advance\leftskip\@tempdima
%      \hskip -\leftskip
%      #1\nobreak\hfil \nobreak\hbox to\@pnumwidth{\hss #2}\par
%      \penalty\@highpenalty
%    \endgroup
%  \fi}

\renewcommand\l@chapter{\@dottedtocline{1}{1.5em}{2.3em}}
\renewcommand\l@section{\@dottedtocline{2}{3.8em}{3.2em}}
\renewcommand\l@subsection{\@dottedtocline{3}{7.0em}{4.1em}}
\renewcommand\l@subsubsection{\@dottedtocline{4}{10em}{5em}}
\renewcommand\l@paragraph{\@dottedtocline{5}{12em}{6em}}


%
% ------ Special captions ---------------------
%
% \caption[]{text} produces normal caption and numbering
% \caption(-){(continued)} produces `(continued)' caption and 
%        same-as-last caption number
% \caption(x)[]{text} produces lettered caption.  1.1a, 1.1b, ...
%        If (x) is (a) or (A) then caption number is incremented,
%        else it is same numbered.

\def\thecaptionletter{}
\newif\ifcaptiontotoc\captiontotoctrue

\def\caption{\@ifnextchar({\@specialcaption}{\@normalcaption}}

\def\@normalcaption{\refstepcounter\@captype \@dblarg{\@caption\@captype}}
\def\@specialcaption(#1){%
  \def\thecaptionletter{#1}%
  \captiontotocfalse
  \if#1-\def\thecaptionletter{}\fi
  \if#1a\refstepcounter\@captype\captiontotoctrue\fi
  \if#1A\refstepcounter\@captype\captiontotoctrue\fi
  \@dblarg{\@caption\@captype}}

\long\def\@caption#1[#2]#3{\par
  \ifcaptiontotoc
    \addcontentsline{\csname
    ext@#1\endcsname}{#1}{\protect\numberline{\csname
    the#1\endcsname}{\ignorespaces #2}}%
  \fi
  \begingroup
    \@parboxrestore
    \normalsize
    \def\baselinestretch{1.0}
    \@makecaption{\csname fnum@#1\endcsname
        \thecaptionletter}{\ignorespaces #3}\par
  \endgroup}

\def\@listI{\leftmargin\leftmargini \parsep 7pt plus 3pt minus 1pt\topsep
 12pt plus 5pt minus 6pt\itemsep 7pt plus 3pt minus 1pt}
 
 
%
%  ----  Facing pages and double-page figures and tables
%
%  \begin{fullpage} ... \end{fullpage}
%  \begin{leftfullpage} ... \end{leftfullpage}

\newif\if@LP \@LPfalse

\newbox\@@wholepage
\def\fullpage{\setbox\@@wholepage=\vbox\bgroup}
\def\endfullpage{\egroup\dp\@@wholepage\z@
   \vbox to\textheight{\vss\unvbox\@@wholepage\vss}}
\def\leftfullpage{\setbox\@@wholepage=\vbox\bgroup}
\def\endleftfullpage{\egroup\dp\@@wholepage\z@
   \vbox to\textheight{\vss\unvbox\@@wholepage\vss}\global\@LPtrue}

\let\oldend@float\end@float
\def\end@float{%
  \if@LP\global\@namedef{LP:\expandafter\string\@currbox}{L}%
  \else \global\@namedef{LP:\expandafter\string\@currbox}{X}%
  \fi
   \global\@LPfalse
  \oldend@float
}


\if@twoside

% reject a left-side float that appears on an odd page
 \let\old@xtryfc\@xtryfc
 \def\@xtryfc #1{%
   \expandafter\if\csname LP:\string#1\endcsname L%
      % \typeout{facing page in xtryfc}%
      \ifodd\count0\global\@colht\z@
          \typeout{I moved a leftpage float from page \the\count0.}%
      \fi\fi
    \old@xtryfc #1}

\else

% flip a facing page caption
 \let\@oldwtryfc\@wtryfc
 \def\@wtryfc #1{%
  \expandafter\if\csname LP:\string#1\endcsname L\gdef\LP@page{}%
   % \typeout{facing page in wtryfc}%
   \fi
   \@oldwtryfc #1}

 \let\old@shipoutsetup\@shipoutsetup
 \def\@shipoutsetup{%
   \@ifundefined{LP@page}
     {\let\@themargin\oddsidemargin \let\@thehead\@oddhead}
     {\let\@themargin\evensidemargin \let\@thehead\@evenhead
      % \typeout{Formatting a left-hand one-side page.}%
      }
   \global\let\LP@page\relax
   \old@shipoutsetup
 }
\fi

%
%  ----  Preliminary pages  ---------------------------
%
\def\prelimpages{ % sets page numbering for the preliminary pages
   \pagestyle{empty} % will be {plain} at start of toc
   \pagenumbering{roman}
   \setcounter{page}{1}
   \textheight 225mm  % add separation for page numbers (vers 1.3)
      \footskip 30pt
   % \ifarchitect \textwidth 145mm \oddsidemargin 118pt\fi
   }
%
%      (The following macros are used once and discarded)
%
%  Title page
%
%  options and defaults
%
\edef\todayday{\number\day.\number\month.\number\year}
\def\kuu{\ifcase\month\or
  Tammikuu\or Helmikuu\or Maaliskuu\or Huhtikuu\or Toukokuu\or Kesäkuu\or
  Heinäkuu\or Elokuu\or Syyskuu\or Lokakuu\or Marraskuu\or Joulukuu\fi
  \space\number\year}

\def\Title#1{\gdef\@Title{#1}}
\def\Author#1{\gdef\@Author{#1}}
\def\Year#1{\gdef\@Year{#1}}  \Year{\year}
\def\Today#1{\gdef\@Today{#1}} \Today{\todayday}
\def\Degree#1{\gdef\@Degree{#1}} \Degree{Pro gradu}
%
\def\School#1{\gdef\@School{#1}} \School{Tampereen yliopisto}
\def\Department#1{\gdef\@Department{#1}}
\Department{Tietojenkäsittelytieteiden laitos}
\def\Degreetext#1{\gdef\@Degreetext{#1}} 
  \Degreetext{ -tutkielma}
\def\Supervisor#1{\gdef\@Supervisor{#1}}
\newcount\@Signatures 
\def\Signatures#1{\global\@Signatures=#1\relax}
  \Signatures{3} % number of signature lines
 
\def\textofby#1{\gdef\@textofby{#1}}  \textofby{by}
\def\textofApproved#1{\gdef\@textofApproved{#1}}  \textofApproved{Approved by}
\def\textofChair#1{\gdef\@textofChair{#1}}  
       \textofChair{(Chairperson of Supervisory Committee)}
\def\textofProgram#1{\gdef\@textofProgram{#1}}  
       \textofProgram{Program Authorized}
\def\textoftoOffer#1{\gdef\@textoftoOffer{#1}}  
       \textoftoOffer{to Offer Degree}
\def\textofDate#1{\gdef\@textofDate{#1}}  \textofDate{Date}

\def\titlepage{                   % Prints the title page
    \vspace*{5cm}
    \begin{center}
      {\Large\bf
      \@Title}\par
      \vspace*{2cm}\relax
      {\large \@Author}
    \end{center}
    \vspace*{7cm}
    \par
    \makebox[60mm]{}\@School
    \par
    \makebox[60mm]{}\@Department
    \par
    \makebox[60mm]{}\@Degree\@Degreetext
    \par
    \makebox[60mm]{}Ohjaaja: \@Supervisor
    \par
    \makebox[60mm]{}\@Today
    \par
    \vskip0pt plus1fill\relax
    
  \let\titlepage\relax}
 
%   Quote slip
%
\def\textofSignature#1{\gdef\@textofSignature{#1}}  \textofSignature{Signature}
\long\def\quoteslip#1{
   \cleardoublepage
   \null
   \vskip0pt plus1fill\relax
   \noindent #1\par
   \vskip3pc
   \begin{flushright}
      \makebox[3in]{\@textofSignature\hrulefill}
      \par\vskip2pc
      \makebox[3in]{\@textofDate\hrulefill}
   \end{flushright}
   \vskip0pt plus2fill\relax
   \let\quoteslip\relax}

\def\@pages{\pageref{end-of-document}}
%
%   Abstract
%
%  normal parameters
\def\textofAbstract#1{\gdef\@textofAbstract{#1}}  \textofAbstract{Tiivistelmä}
\long\def\abstract#1{
   \cleardoublepage
      \setlength{\parindent}{0mm} 
      \@School
      \par
      \@Department
      \par
      \@Author: \@Title
      \par
      \@Degree\@Degreetext, \@pages~sivua
      \par
      \kuu
      \par\
      \vskip1.5ex\hrule\par
      \vskip1.5ex
      {\bf \@textofAbstract}
   \par#1
   \vfill
   \let\abstract\relax}
   \setlength{\parindent}{1.5 em}
%
%
%   Table of contents (right side page) (always page `i')
%
%
\def\textofToC#1{\gdef\@textofToC{#1}}  \textofToC{Sisällys}
\def\tableofcontents{\cleardoublepage
   \chapter*{\@textofToC\@mkboth{}{}}
   \pagestyle{plain}
   \thispagestyle{empty}
   \setcounter{page}{1}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{toc}
    }
   }
%
%   List of figures
%
\def\textofLoF#1{\gdef\@textofLoF{#1}}  \textofLoF{Kuvat}
\def\listoffigures{\chapter*{\@textofLoF\@mkboth{}{}}
   \thispagestyle{plain}
   \addcontentsline{toc}{chapter}{\protect\@textofLoF}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{lof}
    }
   }
%
%   List of tables
%
\def\textofLoT#1{\gdef\@textofLoT{#1}}  \textofLoT{Taulut}
\def\listoftables{\chapter*{\@textofLoT\@mkboth{}{}}
   \thispagestyle{plain}
   \addcontentsline{toc}{chapter}{\protect\@textofLoT}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{lot}
    }
   }
%
%  Bibliography
%
\def\textofBIB#1{\gdef\@textofBIB{#1}}  \textofBIB{References}
\def\thebibliography#1{\chapter*{\@textofBIB\@mkboth{}{}}
 \addcontentsline{toc}{chapter}{\protect\@textofBIB}
 \list
 {[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
 \advance\leftmargin\labelsep
 \usecounter{enumi}}
 \def\newblock{\hskip .11em plus .33em minus .07em}
 \sloppy\clubpenalty4000\widowpenalty4000
 \sfcode`\.=1000\relax}
 
%
%   Acknowledgments
%
\def\textofAck#1{\gdef\@textofAck{#1}}  \textofAck{Kiitokset}
\long\def\acknowledgments#1{\chapter*{\@textofAck\@mkboth{}{}}
   \thispagestyle{plain}
   #1\par
   \vfill
   \let\acknowledgments\relax}
 
%
%   Dedication
%
\def\textofDed#1{\gdef\@textofDed{#1}}  \textofDed{Omistettu}
\long\def\dedication#1{\chapter*{\@textofDed\@mkboth{}{}}
   \thispagestyle{plain}
   #1\par
   \vfill
   \let\dedication\relax}
 
%
%   Vita
%
\def\textofVita#1{\gdef\@textofVita{#1}}  \textofVita{Vita}
\long\def\vita#1{\chapter*{\@textofVita\@mkboth{}{}}
   #1\par
   \vfill
   \let\vita\relax}
 
%
%   Gratis definition of a glossary environment
%
\renewenvironment{glossary}
  {\begin{list}{}{\setlength\itemindent{\parindent}
   \def\makelabel##1{\footnotesize\uppercase{##1:}\hfill}}}
  {\end{list}}

% Lisäys utathesikseen

% End of the utathesis style
