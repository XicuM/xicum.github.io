---
title: Crea tu currículum con LaTeX
date: 2025-12-24T10:29:05+01:00
comments: true
showToc: true
draft: false
tags: [LaTeX]
cover:
    image: /posts/cv/cover.png
---

Muchas veces, cuando queiero actualizar mi currículum, acabo pasando más tiempo peleándome con el formato que haciendo la pequeña modificación que quería. Frustrado por esto, pensé que debería haber una forma más rápida de hacerlo. 

Una buena solución a este problema consiste en separar el contenido del formato. Esto significa tener un archivo que contenga la información personal y otro archivo que defina su estilo. De esta manera, únicamente debes modificar la información personal, puesto que el estilo se mantiene.

Para construir una solución basada en esta idea, me fijé en LaTex, una herramienta muy utilizada para la preparacipapers y libros. Para facilitar la introducción de datos en Latex desde una plantilla, la herramienta más adecuada es Pandoc.  

Así, uniendo LaTeX y Pandoc, es posible ofrecer una forma sencilla de generar un CV profesional a partir de una plantilla sencilla. Cada vez que necesites actualizar tu CV, solo tendrás que modificar el archivo YAML y regenerar el PDF. 

La arquitectura de esta solución es sencilla. Pandoc lee tus datos de un archivo YAML, que es un formato estructurado fácil de aprender y similar a JSON. Una vez obtenidos los datos, Pandoc los injecta en el archivo LaTeX con el estilo que queremos y genera el PDF a partir de él:

**YAML** *(Los Datos)* + **LaTeX** *(El estilo)* → **Pandoc** *(El Motor)* → **PDF** *(El Resultado)*

---

A continuación te explico cómo crear un currículum profesional en 5 simples pasos:

## 1. Requisitos previos

Necesitarás tener instaladas las dos herramientas principales en tu sistema:
- **Pandoc**, el "convertidor universal de documentos". Puedes leer las instrucciones de instalación [aquí](https://pandoc.org/installing.html).
- **Distribución TeX** que proporciona el motor para renderizar PDFs. Las opciones recomendadas son:
  - Windows: [MiKTeX](https://miktex.org/download)
  - MacOS: [MacTeX](https://tug.org/mactex/)
  - Linux: TeX Live via your package manager.

Verifica tu instalación ejecutando los siguientes comandos en el terminal:

```bash
pandoc --version
pdflatex --version
```

Deberían mostrar información sobre la versión. Si no es así, asegúrate de que estén correctamente instalados y añadidos al PATH de tu sistema.

## 2. Crear el archivo YAML

Crea un archivo YAML. Puede llamarse, por ejemplo, `cv.yaml`. Este archivo almacenará tu información personal y las secciones de tu CV, actuando como tu "Fuente Única de Verdad". Si consigues un nuevo trabajo o cambias tu número de teléfono, este es el único archivo que necesitarás editar.

Es necesario escribir siguiendo la sintaxis YAML. No te preocupes, está diseñado para ser legible y fácil de escribir. Para referencia, puedes consultar la [especificación YAML](https://yaml.org/spec/1.2/spec.html).

Aquí tienes un ejemplo de YAML con mis datos:

```yaml
name: "Xicu Marí Prats"
profile: >
  Ingeniero de investigación con más de 3 años de experiencia práctica en diseño 
  de hardware digital. Buscando oportunidades en entornos de I+D para impulsar la innovación.

contact:
  email: "hi@xicu.net"
  website: "xicu.net"
  linkedin: "linkedin.com/in/xicu"

key_skills: [
  "VHDL", "SystemVerilog", "Xilinx Vivado", "Altera Quartus II", "FPGA Design",
  "OpenPiton", "C/C++", "Python", "Cadence", "KiCad", "Altium", "Linux", "Git"
]

professional_experience:
  - position: "Research Engineer"
    company: "HPDSA Group at Barcelona Supercomputing Center"
    dates: "Dec 2024 -- Present"
    details:
      - "Implementación de un acelerador DAE de última generación para cargas de trabajo de IA."
      - "Integración de módulos de hardware en el framework OpenPiton."

education:
  - degree: "Máster en Ingeniería Electrónica"
    institution: "Universitat Politècnica de Catalunya"
    dates: "Sep 2022 -- Sep 2025"
    details:
      - "Nota media: 9.1 / 10"
```

> **Nota**: Si tus datos contienen caracteres especiales de LaTeX como & o %, recuerda escaparlos (por ejemplo, 80\%) para evitar errores de compilación.

## 3. Crear la plantilla

Ahora, definamos el estilo de tu CV. Pandoc trata esto como una **plantilla**, donde las variables serán sustituidas por los datos de tu archivo YAML.

Un ejemplo mínimo podría ser el siguiente. Aquí, las `$variables$` serán reemplazadas por su correspondiente valor. Los bucles como `$for(experience)$ … $endfor$` te permiten repetir bloques para cada elemento de una lista. Puedes guardar el archivo como `cv.tex`:

```tex
\documentclass[11pt,a4paper]{article}
\usepackage{geometry}
\geometry{margin=2cm}
\usepackage{enumitem}
\usepackage{hyperref}

\begin{document}

\begin{center}
    {\Huge \textbf{$name$}} \\[0.5em]
    \href{mailto:$contact.email$}{$contact.email$} | \href{https://$contact.website$}{$contact.website$} | \href{https://$contact.linkedin$}{$contact.linkedin$}
\end{center}

\vspace{1em}

\section*{Education}
$for(education)$
\textbf{$education.degree$}, $education.institution$ \hfill $education.dates$ \\
$endfor$

\section*{Experience}
$for(professional_experience)$
\textbf{$professional_experience.position$} --- $professional_experience.company$ \hfill $professional_experience.dates$ \\
\begin{itemize}[leftmargin=*]
$for(professional_experience.details)$
    \item $professional_experience.details$
$endfor$
\end{itemize}
$endfor$

\end{document}
```

## 4. Generar el PDF

Con todo listo, puedes generar el PDF de tu CV con el siguiente comando en el terminal:

```bash
pandoc cv.yaml \
    --template=cv.tex \
    -o cv.pdf \
    --pdf-engine=pdflatex
```

Este comando le indica a Pandoc que:
1. Cargue los datos de `cv.yaml`.
2. Use `cv.tex` como plantilla.
3. Genere un PDF mediante `pdflatex`.

## 5. La herramienta completa

Estos cuatro pasos pueden ser automatizados para reducir la fricción. Como ahora ya sabes cómo funciona esta solución por dentro, es momento de prentarte a `cv-cli`, una herramientas de comandos de terminal disponible en el siguiente repositorio público:

👉 [https://github.com/XicuM/cv-cli](https://github.com/XicuM/cv-cli)

Para usar esta utilidad, debes primero instalarla. Descarga el código fuente del repositorio y abre una terminal desde el directorio principal del código. Una vez allí, ejecuta:

```bash
pip install --user -e .
```

Una vez instalado, ya podrás usarlo. Los comandos principales son los siguientes:

```bash
cv init               # Inicia el projecto con las plantillas para rellenar
cv cv -l en           # Crea un CV en Inglés
cv letter acme -l es  # Crea una carta en Español para la empresa "acme"
cv template cv        # Edita la plantilla del CV
cv build              # Construye todo el proyecto
cv build -t cv -l en  # Construye solo el CV en Inglés
cv clean              # Limpia la cache del proyecto
```

Si pruebas con `cv init` y posteriormente con `cv build`, se generará una carpeta llamada `output` con los siguientes documentos:

| cv-en.pdf | template-en.pdf |
| --- | --- |
| ![](/posts/cv/cv-en.png) | ![](/posts/cv/letter-en.png) |

¡Con esto ya tendrás un Currícum Vitae profesional en mano! A partir de aquí, solo tendrás que ajustar el archivo LaTex al estilo que más te guste una sola vez y actualizar el archivo .yaml cada vez que termines una etapa profesional.

Si tienes algún problema con Pandoc o LaTeX, o con la herramienta `cv-cli`, no dudes en dejar un comentario abajo. ¡Te leo!
