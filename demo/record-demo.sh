#!/bin/bash
set -e
G=$'\033[0;32m' R=$'\033[0;31m' Y=$'\033[0;33m' B=$'\033[1m' D=$'\033[2m' Z=$'\033[0m' C=$'\033[0;36m'

type_cmd() {
  printf "${D}\$ ${Z}"
  for ((i=0; i<${#1}; i++)); do printf "%s" "${1:$i:1}"; sleep 0.03; done
  echo ""
}

clear
echo ""
echo "  ${B}AgentStack${Z} ${D}v1.0${Z}"
echo "  ${D}Security + Routing + Automation + Knowledge + Self-Improvement${Z}"
echo ""
sleep 1

type_cmd "agent-stack install"
sleep 0.5

echo ""
echo "  ${G}+${Z} ${B}GuardRail${Z}          11 security guards installed"
sleep 0.3
echo "  ${G}+${Z} ${B}Model Router${Z}       4 tiers configured (haiku/sonnet/opus/vision)"
sleep 0.3
echo "  ${G}+${Z} ${B}Night Shift${Z}        Nightly cron scheduled at 02:00"
sleep 0.3
echo "  ${G}+${Z} ${B}Graphify${Z}           Knowledge graph ready to build"
sleep 0.3
echo "  ${G}+${Z} ${B}Autonomie-OS${Z}       Self-improvement loop active"
sleep 0.5

echo ""
echo "  ${G}${B}All 5 components active.${Z}"
echo ""
sleep 1

echo "  ${B}Live:${Z} Agent tries to push to main..."
sleep 0.3
echo "  ${R}BLOCKED${Z}  ${D}GuardRail: main_push_guard${Z}"
echo ""
sleep 0.5

echo "  ${B}Live:${Z} Agent needs a model..."
sleep 0.3
echo "  ${C}ROUTED${Z}   ${D}Model Router: standard -> claude-sonnet-5${Z}"
echo ""
sleep 0.5

echo "  ${B}02:00:${Z} Night Shift runs..."
sleep 0.3
echo "  ${G}FIXED${Z}    ${D}3 lint errors, 1 security issue auto-patched${Z}"
echo ""
sleep 1

echo "  ${B}One install. Five tools. Zero configuration.${Z}"
echo ""
sleep 3
