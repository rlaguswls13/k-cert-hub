# Domain Mindmap — 정보처리기사 실기 2단계 분류 체계 및 임박도 모델

## 1. 2단계 분류 체계 (카테고리2 × 카테고리1)

```mermaid
graph LR
    Root["정보처리기사 실기 기출 (360문항)"] --> Cat2_Theory["카테고리2: 이론 문제 (208문항, 57.8%)"]
    Root --> Cat2_Code["카테고리2: 코드 문제 (152문항, 42.2%)"]

    Cat2_Theory --> T1["[이론] 네트워크/프로토콜 (38문항)"]
    Cat2_Theory --> T2["[이론] 보안/암호화/공격기법 (36문항)"]
    Cat2_Theory --> T3["[이론] 데이터베이스 이론/정규화 (36문항)"]
    Cat2_Theory --> T4["[이론] SW공학/설계/디자인패턴 (33문항)"]
    Cat2_Theory --> T5["[이론] 운영체제/병행제어/교착상태 (20문항)"]
    Cat2_Theory --> T6["[이론] 테스트/품질/복잡도 (20문항)"]
    Cat2_Theory --> T7["[이론] 프로젝트관리/신기술/기타 (19문항)"]
    Cat2_Theory --> T8["[이론] 인터페이스/통합/미들웨어 (6문항)"]

    Cat2_Code --> C1["[코드] C언어 (58문항)"]
    Cat2_Code --> C2["[코드] Java (48문항)"]
    Cat2_Code --> C3["[코드] Python (22문항)"]
    Cat2_Code --> C4["[코드] SQL/데이터베이스 실습 (15문항)"]
    Cat2_Code --> C5["[코드] 관계대수/블록다이어그램 (9문항)"]
```

## 2. 출제 임박도 지수 ($\text{Imminence Index}$) 산출 공식

각 세부 유형 $i$에 대해 등장한 회차 순번 집합을 $R_i = \{r_1, r_2, \dots, r_k\}$ ($1 \le r_j \le 18$)라 할 때:

- **평균 출제 간격 ($\text{Avg Interval}$)**:
  $$\bar{d}_i = \frac{1}{k-1} \sum_{j=1}^{k-1} (r_{j+1} - r_j)$$
- **미출제 경과 회차 ($\text{Rounds Since Last}$)**:
  $$\Delta r_i = 18 - r_k$$
- **출제 임박도 지수 ($\text{Imminence Index}$)**:
  $$I_i = \text{round}\left(\frac{\Delta r_i + 1}{\bar{d}_i}, 2\right)$$
  - $I_i \ge 1.5$: **출제 임박** (평균 주기를 초과하여 미출제된 상태)
  - $I_i = 1.0 \text{ (매회 출제 상수형)}$: **매회 필수 출제** (네트워크, 보안, DB이론, C언어, Java 등)
