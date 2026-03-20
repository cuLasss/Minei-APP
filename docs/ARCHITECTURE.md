# Arquitetura Técnica — Minei App

Este documento descreve as decisões técnicas de alto nível e a organização do código-fonte do **Minei App**.

## 🏗️ Padrão Arquitetural

O projeto utiliza uma estrutura modular, com separação de responsabilidades inspirada nos princípios da Clean Architecture, adaptada para projetos Flutter de menor escala que exigem agilidade.

### Organização de Pastas

```yaml
lib/
├── screens/             # Camada de Interface (Widgets, Screens, Pages).
├── services/            # Lógica de Negócio (Consultas, Cálculos, Mockups).
├── providers/           # Gerenciamento de Estado (Theme, Auth, Data).
├── utils/               # Formatação, Validadores e Conversores.
└── main.dart            # Iniclização e Configuração Global.
```

## 🧠 Gerenciamento de Estado

Utilizamos o **Provider Pattern** como solução nativa de gerenciamento de estado por sua simplicidade e excelente integração com o ciclo de vida do Flutter. Isso garante que a interface reflita instantaneamente mudanças no tema ou nos dados de preços sem prejudicar a performance.

## 🎨 Design e UI

- **Poppins Font**: Tipografia moderna focada em legibilidade.
- **Custom Themes**: Utilização intensiva do `ThemeData` do Flutter para garantir uma interface consistente em modo claro e escuro.
- **Responsividade**: Widgets construídos com `LayoutBuilder` para adaptação proporcional entre diferentes tamanhos de tela.

## 💾 Persistência de Dados (Mock/Service)

Atualmente, o app utiliza um **PriceMap Service** que simula uma base de dados reativa. A estrutura foi desenhada para ser facilmente substituída por um backend real (SQLite, Firebase ou API REST) sem necessidade de refatorar a camada de UI.

---
**Status Técnico:** MVP completo e funcional.
**Meta Futura:** Integração com APIs de geolocalização e automação de preços.
