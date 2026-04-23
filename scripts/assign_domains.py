#!/usr/bin/env python3
"""
assign_domains.py — Asignación de dominios anticopia para bootcamps ergrato-dev

Uso:
    python3 scripts/assign_domains.py --input aprendices.csv --output asignaciones.csv
    python3 scripts/assign_domains.py --input aprendices.csv --trimestre 2026-Q2
    python3 scripts/assign_domains.py --input aprendices.csv --pdf asignaciones.pdf
    python3 scripts/assign_domains.py --input aprendices.csv --output out.csv --pdf out.pdf

Formato del CSV de entrada (aprendices.csv):
    nombre,ficha,bootcamp
    Juan Pérez,2850123,bc-sql
    Ana Torres,2850123,bc-mobile
    ...

Formato del CSV de salida (asignaciones.csv):
    nombre,ficha,bootcamp,dominio,entidades
    Juan Pérez,2850123,bc-sql,Clínica veterinaria,"animals, owners, appointments, treatments"
    ...
"""

import argparse
import csv
import random
import sys
from pathlib import Path

# ── Catálogo de dominios ──────────────────────────────────────────────────────
# Formato: (id, nombre, entidades_principales)
# Los marcados con reserved=True están reservados para ejemplos del bootcamp.
DOMAINS = [
    (1,   "Biblioteca",                       "books, members, loans, authors",                         True),
    (2,   "Farmacia",                          "medicines, sales, inventory, suppliers",                 True),
    (3,   "Gimnasio",                          "members, routines, attendance, trainers",                True),
    (4,   "Escuela",                           "students, courses, grades, teachers",                    True),
    (5,   "Tienda de mascotas",                "animals, products, sales, customers",                    True),
    (6,   "Restaurante",                       "dishes, tables, orders, ingredients",                    True),
    (7,   "Banco",                             "accounts, transactions, clients, branches",              True),
    (8,   "Agencia de taxis",                  "drivers, vehicles, trips, customers",                    True),
    (9,   "Hospital",                          "patients, doctors, appointments, rooms",                 True),
    (10,  "Cine",                              "movies, rooms, screenings, tickets",                     True),
    (11,  "Hotel",                             "rooms, guests, reservations, services",                  True),
    (12,  "Agencia de viajes",                 "packages, bookings, destinations, clients",              True),
    (13,  "Concesionario de autos",            "vehicles, customers, sales, financing",                  True),
    (14,  "Tienda de ropa",                    "products, sizes, sales, suppliers",                      True),
    (15,  "Taller mecánico",                   "vehicles, repairs, parts, mechanics",                    True),
    (16,  "Clínica veterinaria",               "animals, owners, appointments, treatments",              False),
    (17,  "Consultorio odontológico",          "patients, appointments, procedures, dentists",           False),
    (18,  "Laboratorio clínico",               "patients, tests, results, technicians",                  False),
    (19,  "Centro de rehabilitación física",   "patients, therapists, sessions, exercises",              False),
    (20,  "Óptica",                            "customers, glasses, prescriptions, optometrists",        False),
    (21,  "Academia de idiomas",               "students, languages, levels, instructors",               False),
    (22,  "Escuela de música",                 "students, instruments, lessons, teachers",               False),
    (23,  "Academia de artes marciales",       "students, belts, classes, instructors",                  False),
    (24,  "Escuela de danza",                  "students, styles, rehearsals, instructors",              False),
    (25,  "Centro de tutorías",                "students, subjects, sessions, tutors",                   False),
    (26,  "Plataforma de cursos online",       "courses, students, enrollments, lessons",                False),
    (27,  "Guardería / Jardín infantil",       "children, parents, activities, caregivers",              False),
    (28,  "Escuela de cocina",                 "students, recipes, classes, chefs",                      False),
    (29,  "Panadería",                         "products, ingredients, orders, suppliers",               False),
    (30,  "Cafetería",                         "products, tables, orders, staff",                        False),
    (31,  "Servicio de catering",              "events, menus, bookings, staff",                         False),
    (32,  "Heladería",                         "flavors, products, sales, branches",                     False),
    (33,  "Pizzería con delivery",             "products, orders, deliveries, customers",                False),
    (34,  "Mercado campesino",                 "vendors, products, sales, customers",                    False),
    (35,  "Librería",                          "books, authors, sales, customers",                       False),
    (36,  "Ferretería",                        "products, categories, sales, suppliers",                 False),
    (37,  "Papelería",                         "products, stock, sales, customers",                      False),
    (38,  "Tienda de electrónica",             "products, warranties, sales, repairs",                   False),
    (39,  "Tienda de bicicletas",              "bikes, parts, sales, repairs",                           False),
    (40,  "Tienda de instrumentos musicales",  "instruments, brands, sales, rentals",                    False),
    (41,  "Tienda de juguetes",                "products, age_ranges, sales, suppliers",                 False),
    (42,  "Tienda de muebles",                 "products, materials, orders, deliveries",                False),
    (43,  "Joyería",                           "jewelry, materials, sales, customers",                   False),
    (44,  "Floristería",                       "flowers, arrangements, orders, events",                  False),
    (45,  "Parque de atracciones",             "rides, tickets, visitors, maintenance",                  False),
    (46,  "Escape room",                       "rooms, bookings, teams, clues",                          False),
    (47,  "Sala de videojuegos / Arcade",      "machines, tokens, players, maintenance",                 False),
    (48,  "Teatro",                            "plays, seats, shows, tickets",                           False),
    (49,  "Liga de fútbol amateur",            "teams, players, matches, scores",                        False),
    (50,  "Club de natación",                  "swimmers, categories, competitions, coaches",            False),
    (51,  "Academia de tenis",                 "courts, players, lessons, tournaments",                  False),
    (52,  "Club de ciclismo",                  "cyclists, routes, events, rankings",                     False),
    (53,  "Pista de patinaje",                 "sessions, rentals, customers, instructors",              False),
    (54,  "Estadio deportivo",                 "events, seats, tickets, concessions",                    False),
    (55,  "Empresa de mensajería / Courier",   "packages, routes, drivers, customers",                   False),
    (56,  "Empresa de mudanzas",               "services, vehicles, crews, clients",                     False),
    (57,  "Terminal de buses",                 "routes, schedules, tickets, passengers",                 False),
    (58,  "Empresa de transporte escolar",     "routes, students, vehicles, drivers",                    False),
    (59,  "Marina deportiva",                  "boats, berths, owners, services",                        False),
    (60,  "Inmobiliaria",                      "properties, agents, clients, contracts",                 False),
    (61,  "Administración de edificios",       "units, owners, fees, maintenance",                       False),
    (62,  "Parqueadero",                       "vehicles, spots, rates, payments",                       False),
    (63,  "Coworking space",                   "spaces, members, bookings, services",                    False),
    (64,  "Alquiler de equipos de construcción", "equipment, rentals, clients, maintenance",             False),
    (65,  "Campamento / Glamping",             "sites, guests, reservations, activities",                False),
    (66,  "Soporte técnico / Help desk",       "tickets, agents, categories, resolutions",               False),
    (67,  "Empresa de proyectos de software",  "projects, developers, tasks, sprints",                   False),
    (68,  "Tienda de reparación de celulares", "devices, repairs, parts, customers",                     False),
    (69,  "Agencia de marketing digital",      "clients, campaigns, metrics, channels",                  False),
    (70,  "Cooperativa de ahorro y crédito",   "members, accounts, loans, payments",                     False),
    (71,  "Casa de cambio",                    "currencies, transactions, rates, clients",               False),
    (72,  "Aseguradora",                       "policies, clients, claims, agents",                      False),
    (73,  "Museo",                             "exhibits, artifacts, visitors, tours",                   False),
    (74,  "Zoológico",                         "animals, species, habitats, keepers",                    False),
    (75,  "Acuario",                           "tanks, species, fish, feedings",                         False),
    (76,  "Planetario",                        "shows, telescopes, visitors, events",                    False),
    (77,  "Jardín botánico",                   "plants, species, zones, guides",                         False),
    (78,  "Reserva natural / Ecoturismo",      "trails, guides, visitors, wildlife",                     False),
    (79,  "Hacienda / Finca agrícola",         "crops, fields, harvests, workers",                       False),
    (80,  "Vivero de plantas",                 "plants, categories, sales, suppliers",                   False),
    (81,  "Empresa apícola",                   "hives, harvests, products, technicians",                 False),
    (82,  "Granja avícola",                    "flocks, coops, production, sales",                       False),
    (83,  "Empresa pesquera",                  "vessels, catches, species, ports",                       False),
    (84,  "Planta de reciclaje",               "materials, batches, processes, clients",                 False),
    (85,  "Empresa de energía solar",          "installations, panels, clients, maintenance",            False),
    (86,  "Empresa de agua potable",           "connections, consumption, billing, sectors",             False),
    (87,  "Empresa de residuos / Recolección", "routes, trucks, neighborhoods, collections",             False),
    (88,  "Constructora",                      "projects, contractors, materials, phases",               False),
    (89,  "Arquitecto / Estudio de diseño",    "projects, clients, blueprints, budgets",                 False),
    (90,  "Empresa de seguridad privada",      "guards, clients, shifts, incidents",                     False),
    (91,  "Empresa de limpieza",               "clients, services, staff, schedules",                    False),
    (92,  "Lavandería / Tintorería",           "orders, garments, customers, pricing",                   False),
    (93,  "Peluquería / Barbería",             "customers, stylists, appointments, services",            False),
    (94,  "Spa y bienestar",                   "clients, treatments, therapists, packages",              False),
    (95,  "Centro de tatuajes",                "clients, artists, sessions, designs",                    False),
    (96,  "Fotografía y video",                "clients, sessions, packages, deliveries",                False),
    (97,  "Agencia de modelos",                "models, clients, castings, contracts",                   False),
    (98,  "Productora de eventos",             "events, clients, vendors, staff",                        False),
    (99,  "DJ / Sonido y luces",               "events, equipment, clients, bookings",                   False),
    (100, "Editorial",                         "books, authors, editions, distributors",                 False),
    (101, "Estudio de grabación",              "artists, albums, sessions, engineers",                   False),
    (102, "Radio comunitaria",                 "programs, hosts, schedules, sponsors",                   False),
    (103, "Periódico digital",                 "articles, authors, categories, subscribers",             False),
    (104, "Agencia de publicidad",             "clients, campaigns, creatives, budgets",                 False),
    (105, "Empresa de traducción",             "clients, projects, translators, languages",              False),
    (106, "Consultora jurídica",               "clients, cases, lawyers, hearings",                      False),
    (107, "Notaría",                           "clients, documents, notaries, fees",                     False),
    (108, "Empresa de contabilidad",           "clients, reports, accountants, periods",                 False),
    (109, "Empresa de auditoría",              "clients, audits, findings, auditors",                    False),
    (110, "Empresa de recursos humanos",       "candidates, vacancies, clients, interviews",             False),
    (111, "Empresa de capacitación corporativa", "clients, courses, trainers, certifications",           False),
    (112, "Centro de call center",             "agents, calls, clients, campaigns",                      False),
    (113, "Empresa de encuestas",              "surveys, questions, respondents, results",               False),
    (114, "Empresa de logística / Almacén",    "warehouses, products, stock, shipments",                 False),
    (115, "Empresa de importación",            "suppliers, products, shipments, customs",                False),
    (116, "Empresa de exportación",            "products, clients, shipments, certifications",           False),
    (117, "Distribuidora de alimentos",        "products, clients, routes, deliveries",                  False),
    (118, "Cadena de supermercados",           "stores, products, sales, promotions",                    False),
    (119, "Droguería / Minimercado",           "products, sales, suppliers, inventory",                  False),
    (120, "Empresa de vending machines",       "machines, products, locations, restocks",                False),
    (121, "Clínica de fertilidad",             "patients, treatments, doctors, cycles",                  False),
    (122, "Centro de diálisis",                "patients, sessions, nurses, machines",                   False),
    (123, "Banco de sangre",                   "donors, donations, blood_types, requests",               False),
    (124, "Casa hogar / Adultos mayores",      "residents, caregivers, activities, health_records",      False),
    (125, "Centro de adopción de mascotas",    "animals, adopters, applications, outcomes",              False),
    (126, "Fundación / ONG",                   "donors, projects, beneficiaries, reports",               False),
    (127, "Iglesia / Comunidad religiosa",     "members, events, contributions, ministries",             False),
    (128, "Club social",                       "members, events, fees, facilities",                      False),
    (129, "Cooperativa de vivienda",           "members, units, contributions, projects",                False),
    (130, "Empresa de seguros de salud",       "affiliates, plans, claims, providers",                   False),
    (131, "EPS / Prepagada médica",            "patients, services, authorizations, providers",          False),
    (132, "Caja de compensación familiar",     "affiliates, benefits, services, employers",              False),
    (133, "Empresa de pensiones",              "affiliates, contributions, periods, employers",          False),
    (134, "Empresa de nómina / Payroll",       "employees, payrolls, deductions, periods",               False),
    (135, "Universidad privada",               "students, programs, courses, enrollments",               False),
    (136, "Instituto técnico",                 "students, programs, instructors, schedules",             False),
    (137, "SENA / Centro de formación",        "apprentices, programs, instructors, competencies",       False),
    (138, "Colegio bilingüe",                  "students, teachers, subjects, grades",                   False),
    (139, "Jardín infantil privado",           "children, parents, staff, activities",                   False),
    (140, "Empresa de transporte aéreo",       "flights, passengers, aircraft, crews",                   False),
    (141, "Empresa de alquiler de autos",      "vehicles, customers, rentals, incidents",                False),
    (142, "Empresa de alquiler de motos",      "bikes, customers, rentals, maintenance",                 False),
    (143, "Empresa de patinetas eléctricas",   "scooters, zones, trips, users",                          False),
    (144, "Cooperativa de taxis",              "drivers, vehicles, trips, earnings",                     False),
    (145, "Empresa de transporte de carga",    "trucks, loads, routes, clients",                         False),
    (146, "Servicio de grúas / Auxilio vial",  "vehicles, incidents, operators, clients",                False),
    (147, "Empresa de fumigación",             "clients, services, technicians, products",               False),
    (148, "Empresa de jardinería",             "clients, services, workers, schedules",                  False),
    (149, "Empresa de instalaciones eléctricas", "clients, projects, electricians, materials",           False),
    (150, "Empresa de telecomunicaciones",     "clients, plans, lines, invoices",                        False),
]

# Solo dominios disponibles para asignación (no reservados)
AVAILABLE_DOMAINS = [(d[0], d[1], d[2]) for d in DOMAINS if not d[3]]


def load_apprentices(filepath: str) -> list[dict]:
    """Carga la lista de aprendices desde un CSV."""
    apprentices = []
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            apprentices.append({
                "nombre":   row.get("nombre", "").strip(),
                "ficha":    row.get("ficha", "").strip(),
                "bootcamp": row.get("bootcamp", "").strip(),
            })
    return apprentices


def assign(apprentices: list[dict], seed: int | None = None) -> list[dict]:
    """
    Asigna un dominio único por aprendiz (unicidad global dentro del trimestre).
    Si hay más aprendices que dominios disponibles, lanza un error.
    """
    if len(apprentices) > len(AVAILABLE_DOMAINS):
        raise ValueError(
            f"Hay {len(apprentices)} aprendices pero solo "
            f"{len(AVAILABLE_DOMAINS)} dominios disponibles. "
            "Agrega dominios al catálogo antes de continuar."
        )

    rng = random.Random(seed)
    pool = AVAILABLE_DOMAINS.copy()
    rng.shuffle(pool)

    result = []
    for apprentice, domain in zip(apprentices, pool):
        result.append({
            "nombre":    apprentice["nombre"],
            "ficha":     apprentice["ficha"],
            "bootcamp":  apprentice["bootcamp"],
            "dominio":   domain[1],
            "entidades": domain[2],
        })
    return result


def save_csv(rows: list[dict], filepath: str) -> None:
    """Guarda el resultado en CSV."""
    fieldnames = ["nombre", "ficha", "bootcamp", "dominio", "entidades"]
    with open(filepath, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def save_pdf(rows: list[dict], filepath: str, trimestre: str | None = None) -> None:
    """Genera un PDF profesional con la tabla de asignaciones."""
    try:
        import datetime
        from reportlab.lib.pagesizes import A4, landscape
        from reportlab.lib import colors
        from reportlab.lib.units import cm
        from reportlab.platypus import (
            SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
        )
        from reportlab.lib.styles import ParagraphStyle
    except ImportError:
        print(
            "Error: se requiere reportlab para generar PDF.\n"
            "  pip install reportlab",
            file=sys.stderr,
        )
        sys.exit(1)

    C_DARK = colors.HexColor("#1a1a2e")
    C_BLUE = colors.HexColor("#336791")
    C_ALT  = colors.HexColor("#f2f7fb")
    C_WHITE = colors.white
    C_GRAY  = colors.HexColor("#6c757d")
    C_TEXT  = colors.HexColor("#212529")
    C_GRID  = colors.HexColor("#ced4da")
    C_META  = colors.HexColor("#adb5bd")

    cell_style = ParagraphStyle(
        "cell", fontName="Helvetica", fontSize=8, textColor=C_TEXT, leading=11
    )
    hdr_style = ParagraphStyle(
        "hdr", fontName="Helvetica-Bold", fontSize=8, textColor=C_WHITE, leading=11
    )

    # ── Tabla de asignaciones ─────────────────────────────────────────────
    col_labels = ["#", "Nombre", "Ficha", "Bootcamp", "Dominio asignado", "Entidades principales"]
    table_data = [[Paragraph(h, hdr_style) for h in col_labels]]
    for i, r in enumerate(rows, 1):
        table_data.append([
            Paragraph(str(i),         cell_style),
            Paragraph(r["nombre"],    cell_style),
            Paragraph(r["ficha"],     cell_style),
            Paragraph(r["bootcamp"],  cell_style),
            Paragraph(r["dominio"],   cell_style),
            Paragraph(r["entidades"], cell_style),
        ])

    # Landscape A4: 29.7 cm − 2 × 1.5 cm márgenes = 26.7 cm útiles
    col_widths = [0.8*cm, 4.5*cm, 2.2*cm, 3.0*cm, 5.0*cm, 11.2*cm]

    assignments_table = Table(table_data, colWidths=col_widths, repeatRows=1)
    assignments_table.setStyle(TableStyle([
        ("BACKGROUND",     (0, 0), (-1, 0),  C_BLUE),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [C_WHITE, C_ALT]),
        ("GRID",           (0, 0), (-1, -1), 0.4, C_GRID),
        ("LINEBELOW",      (0, 0), (-1, 0),  1.2, C_DARK),
        ("TOPPADDING",     (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING",  (0, 0), (-1, -1), 5),
        ("LEFTPADDING",    (0, 0), (-1, -1), 6),
        ("RIGHTPADDING",   (0, 0), (-1, -1), 6),
        ("VALIGN",         (0, 0), (-1, -1), "MIDDLE"),
        ("ALIGN",          (0, 0), (0, -1),  "RIGHT"),
    ]))

    # ── Banner superior ───────────────────────────────────────────────────
    date_str        = datetime.date.today().strftime("%-d de %B de %Y")
    trimestre_label = f"Trimestre: {trimestre}  \u00b7  " if trimestre else ""

    title_style = ParagraphStyle(
        "title", fontName="Helvetica-Bold", fontSize=15, textColor=C_WHITE, leading=18
    )
    meta_style = ParagraphStyle(
        "meta", fontName="Helvetica", fontSize=9, textColor=C_META, leading=12
    )

    banner = Table(
        [[
            Paragraph("Asignaciones de Dominios \u2014 Bootcamp SQL", title_style),
            Paragraph(
                f"{trimestre_label}Generado: {date_str}  \u00b7  {len(rows)} aprendices",
                meta_style,
            ),
        ]],
        colWidths=[15*cm, 11.7*cm],
    )
    banner.setStyle(TableStyle([
        ("BACKGROUND",    (0, 0), (-1, -1), C_DARK),
        ("LEFTPADDING",   (0, 0), (-1, -1), 12),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 12),
        ("TOPPADDING",    (0, 0), (-1, -1), 10),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
        ("VALIGN",        (0, 0), (-1, -1), "MIDDLE"),
        ("ALIGN",         (1, 0), (1, 0),   "RIGHT"),
    ]))

    # ── Pie de página ─────────────────────────────────────────────────────
    def on_page(canvas, doc):
        canvas.saveState()
        canvas.setFont("Helvetica", 7)
        canvas.setFillColor(C_GRAY)
        canvas.drawRightString(
            doc.pagesize[0] - 1.5*cm, 0.8*cm, f"P\u00e1gina {doc.page}"
        )
        canvas.restoreState()

    # ── Build ─────────────────────────────────────────────────────────────
    doc = SimpleDocTemplate(
        filepath,
        pagesize=landscape(A4),
        leftMargin=1.5*cm, rightMargin=1.5*cm,
        topMargin=1.5*cm,  bottomMargin=2.0*cm,
        title="Asignaciones de Dominios \u2014 Bootcamp SQL",
    )
    doc.build(
        [banner, Spacer(1, 0.4*cm), assignments_table],
        onFirstPage=on_page,
        onLaterPages=on_page,
    )


def print_table(rows: list[dict]) -> None:
    """Imprime el resultado como tabla en consola."""
    col_nombre   = max(len(r["nombre"])   for r in rows)
    col_ficha    = max(len(r["ficha"])    for r in rows)
    col_bootcamp = max(len(r["bootcamp"]) for r in rows)
    col_dominio  = max(len(r["dominio"])  for r in rows)

    header = (
        f"{'NOMBRE':<{col_nombre}}  "
        f"{'FICHA':<{col_ficha}}  "
        f"{'BOOTCAMP':<{col_bootcamp}}  "
        f"{'DOMINIO':<{col_dominio}}  "
        f"ENTIDADES"
    )
    print(header)
    print("-" * len(header))
    for r in rows:
        print(
            f"{r['nombre']:<{col_nombre}}  "
            f"{r['ficha']:<{col_ficha}}  "
            f"{r['bootcamp']:<{col_bootcamp}}  "
            f"{r['dominio']:<{col_dominio}}  "
            f"{r['entidades']}"
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Asigna dominios únicos a aprendices para bootcamps ergrato-dev."
    )
    parser.add_argument(
        "--input", "-i",
        required=True,
        help="CSV de entrada con columnas: nombre,ficha,bootcamp",
    )
    parser.add_argument(
        "--output", "-o",
        default=None,
        help="CSV de salida con asignaciones (opcional; si se omite, imprime en consola)",
    )
    parser.add_argument(
        "--trimestre", "-t",
        default=None,
        help="Identificador del trimestre como semilla (ej. 2026-Q2). "
             "Garantiza asignaciones reproducibles para el mismo grupo.",
    )
    parser.add_argument(
        "--seed", "-s",
        type=int,
        default=None,
        help="Semilla numérica para aleatoriedad reproducible (alternativa a --trimestre).",
    )
    parser.add_argument(
        "--pdf", "-p",
        default=None,
        metavar="FILE",
        help="Genera un PDF con la tabla de asignaciones (ej. asignaciones.pdf). "
             "Compatible con --output y salida por consola.",
    )
    args = parser.parse_args()

    # Semilla: trimestre como string hash o número directo
    seed: int | None = args.seed
    if seed is None and args.trimestre:
        seed = hash(args.trimestre) % (2**32)

    if not Path(args.input).exists():
        print(f"Error: no se encontró el archivo '{args.input}'", file=sys.stderr)
        sys.exit(1)

    apprentices = load_apprentices(args.input)
    if not apprentices:
        print("Error: el CSV de entrada está vacío.", file=sys.stderr)
        sys.exit(1)

    try:
        assignments = assign(apprentices, seed=seed)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

    if args.output:
        save_csv(assignments, args.output)
        print(f"Asignaciones guardadas en: {args.output} ({len(assignments)} aprendices)")
    else:
        print_table(assignments)

    if args.pdf:
        save_pdf(assignments, args.pdf, trimestre=args.trimestre)
        print(f"PDF generado: {args.pdf} ({len(assignments)} aprendices)")


if __name__ == "__main__":
    main()
