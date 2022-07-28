## SPAD7x7-to-FMC board
FMC daugther card to interface the BrightEyes-TTM with external photon-signals from a commercial 7x7 SPAD (49 channels) detector. The input signals of this board are differential LVDS signals. 

- *Brand:* *custom-built*
- *Product code:* *custom-built*
- BOM and docs: [7x7SPAD_FMC](https://github.com/VicidominiLab/BrightEyes-TTM/tree/v2.0/boards/TTM7x7Adapter/docs)
- **Gerber File:** [Gerber_7x7SPAD_FMC.zip](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/TTM7x7Adapter/TTM7x7Adapter_gerber.zip)


:::{figure} img/3DViewF.png
:align: center
:width: 50%

Fig.1 - I/Os 7x7SPAD-to-FMC connector Board (Front)
:::

:::{figure} img/3DViewB.png
:align: center
:width: 50%

Fig.1 - I/Os 7x7SPAD-to-FMC connector Board (Back)
:::

### Pinout I/Os 7x7SPAD-to-FMC board

| **CH (VHDL)**       |     **DET**     | **CONN** | **NAME HPC** | **FPGA** |
|---------------------|:---------------:|:--------:|:------------:|:--------:|
|          0          | OUT1_P          | D11      | LA05_P       | G29      |
|          0          | OUT1_N          | D12      | LA05_N       | F30      |
|          1          | OUT2_P          | H13      | LA07_P       | E28      |
|          1          | OUT2_N          | H14      | LA07_N       | D28      |
|          2          | OUT3_P          | E6       | HA05_P       | F15      |
|          2          | OUT3_N          | E7       | HA05_N       | E16      |
|          3          | OUT4_P          | J9       | HA07_P       | B14      |
|          3          | OUT4_N          | J10      | HA07_N       | A15      |
|          4          | OUT5_P          | H7       | LA02_P       | H24      |
|          4          | OUT5_N          | H8       | LA02_N       | H25      |
|          5          | OUT6_P          | D8       | LA01_P       | D26      |
|          5          | OUT6_N          | D9       | LA01_N       | C26      |
|          6          | OUT7_P          | E2       | HA01_P       | H14      |
|          6          | OUT7_N          | E3       | HA01_N       | G14      |
|          7          | OUT8_P          | C22      | LA18_P       | F21      |
|          7          | OUT8_N          | C23      | LA18_N       | E21      |
|          8          | OUT9_P          | C18      | LA14_P       | B28      |
|          8          | OUT9_N          | C19      | LA14_N       | A28      |
|          9          | OUT10_P         | J15      | HA14_P       | J16      |
|          9          | OUT10_N         | J16      | HA14_N       | H16      |
|          10         | OUT11_P         | G6       | LA00_P       | C25      |
|          10         | OUT11_N         | G7       | LA00_N       | B25      |
|          11         | OUT12_P         | K10      | HA06_P       | D14      |
|          11         | OUT12_N         | K11      | HA06_N       | C14      |
|          12         | OUT13_P         | F7       | HA04_P       | F11      |
|          12         | OUT13_N         | F8       | HA04_N       | E11      |
|          13         | OUT14_P         | G9       | LA03_P       | H26      |
|          14         | OUT15_P         | G21      | LA20_P       | E19      |
|          14         | OUT15_N         | G22      | LA20_N       | D19      |
|          15         | OUT16_P         | D17      | LA13_P       | A25      |
|          15         | OUT16_N         | D18      | LA13_N       | A26      |
|          16         | OUT17_P         | K16      | HA17_P       | G13      |
|          16         | OUT17_N         | K17      | HA17_N       | F13      |
|          17         | OUT18_P         | K7       | HA02_P       | D11      |
|          17         | OUT18_N         | K8       | HA02_N       | C11      |
|          18         | OUT19_P         | J6       | HA03_P       | C12      |
|          18         | OUT19_N         | J7       | HA03_N       | B12      |
|          19         | OUT20_P         | H10      | LA04_P       | G28      |
|          19         | OUT20_N         | H11      | LA04_N       | F28      |
|          20         | OUT21_P         | C10      | LA06_P       | H30      |
|          20         | OUT21_N         | C11      | LA06_N       | G30      |
|          21         | OUT22_P         | F16      | HA15_P       | H15      |
|          21         | OUT22_N         | F17      | HA15_N       | G15      |
|          22         | OUT23_P         | D23      | LA23_P       | B22      |
|          22         | OUT23_N         | D24      | LA23_N       | A22      |
|          23         | OUT24_P         | E18      | HA20_P       | K13      |
|          23         | OUT24_N         | E19      | HA20_N       | J13      |
|        **24**       | **OUT25_P**     | **E9**   | **HA09_P**   | **F12**  |
|        **24**       | **OUT25_N**     | **E10**  | **HA09_N**   | **E13**  |
|          25         | OUT26_P         | K13      | HA10_P       | A11      |
|          25         | OUT26_N         | K14      | HA10_N       | A12      |
|          26         | OUT27_P         | F4       | HA00_P       | D12      |
|          26         | OUT27_N         | F5       | HA00_N       | D13      |
|          27         | OUT28_P         | D14      | LA09_P       | B30      |
|          27         | OUT28_N         | D15      | LA09_N       | A30      |
|          28         | OUT29_P         | D20      | LA17_P       | F20      |
|          28         | OUT29_N         | D21      | LA17_N       | E20      |
|          29         | OUT30_P         | K22      | HA23_P       | L12      |
|          29         | OUT30_N         | K23      | HA23_N       | L13      |
|          30         | OUT31_P         | G24      | LA22_P       | C20      |
|          30         | OUT31_N         | G25      | LA22_N       | B20      |
|          31         | OUT32_P         | H19      | LA15_P       | C24      |
|          31         | OUT32_N         | H20      | LA15_N       | B24      |
|          32         | OUT33_P         | F10      | HA08_P       | E14      |
|          32         | OUT33_N         | F11      | HA08_N       | E15      |
|          33         | OUT34_P         | C14      | LA10_P       | D29      |
|          33         | OUT34_N         | C15      | LA10_N       | C30      |
|          34         | OUT35_P         | J12      | HA11_P       | B13      |
|          34         | OUT35_N         | J13      | HA11_N       | A13      |
|          35         | OUT36_P         | F19      | HA19_P       | H11      |
|          35         | OUT36_N         | F20      | HA19_N       | H12      |
|          36         | OUT37_P         | H25      | LA21_P       | A20      |
|          36         | OUT37_N         | H26      | LA21_N       | A21      |
|          37         | OUT38_P         | J21      | HA22_P       | L11      |
|          37         | OUT38_N         | J22      | HA22_N       | K11      |
|          38         | OUT39_P         | J18      | HA18_P       | K14      |
|          38         | OUT39_N         | J19      | HA18_N       | J14      |
|          39         | OUT40_P         | E12      | HA13_P       | L16      |
|          39         | OUT40_N         | E13      | HA13_N       | K16      |
|          40         | OUT41_P         | H16      | LA11_P       | G27      |
|          40         | OUT41_N         | H17      | LA11_N       | F27      |
|          41         | OUT42_P         | G12      | LA08_P       | E29      |
|          41         | OUT42_N         | G13      | LA08_N       | E30      |
|          42         | OUT43_P         | E15      | HA16_P       | L15      |
|          42         | OUT43_N         | E16      | HA16_N       | K15      |
|          43         | OUT44_P         | H22      | LA19_P       | G18      |
|          43         | OUT44_N         | H23      | LA19_N       | F18      |
|          44         | OUT45_P         | K19      | HA21_P       | J11      |
|          44         | OUT45_N         | K20      | HA21_N       | J12      |
|          45         | OUT46_P         | G15      | LA12_P       | C29      |
|          45         | OUT46_N         | G16      | LA12_N       | B29      |
|          46         | OUT47_P         | C26      | LA27_P       | C19      |
|          46         | OUT47_N         | C27      | LA27_N       | B19      |
|          47         | OUT48_P         | F13      | HA12_P       | C15      |
|          47         | OUT48_N         | F14      | HA12_N       | B15      |
|          48         | OUT49_P         | G18      | LA16_P       | B27      |
|          48         | OUT49_N         | G19      | LA16_N       | A27      |
|                     |                 |          |              |          |
|                     | VREF1           | G27      | LA25_P       | G17      |
|                     | VREF0           | G28      | LA25_N       | F17      |
|                     | EN_SPAD         | G30      | LA29_P       | C17      |
|                     |                 |          |              |          |
|                     | SDA             | C31      | HPC_IIC_SDA  | IIC MUX  |
|                     | SCL             | C30      | HPC_IIC_SCL  | IIC MUX  |
|                     |                 |          |              |          |
|                     | **IIT ADAPTER** |          |              |          |
|                     | J2              | H28      | LA24_P       | A16      |
|                     | J3              | H29      | LA24_N       | A17      |
|                     | J4              | H31      | LA28_P       | D16      |
|                     | J5              | H32      | LA28_N       | C16      |
|                     | J6              | H34      | LA30_P       | D22      |
|                     | J7              | H35      | LA30_N       | C22      |
|                     | J8              | H37      | LA32_P       | D21      |
| **PX24 Duplicated** | J9              | H38      | LA32_N       | C21      |
