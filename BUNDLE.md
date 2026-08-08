# AgentStack Pricing

## The complete governance layer for AI agents

Every component works standalone. The bundle makes them work together . and adds the features teams need in production.

---

## Free

**Everything you need to start securing AI agents today.**

| Component | What you get |
|---|---|
| [GuardRail](https://github.com/FvdHMBAI/guardrail) | 11 pre-execution security guards (MIT) |
| [Compliance Shield](https://github.com/FvdHMBAI/compliance-shield) | PII detection engine, 10 EU countries (AGPL-3.0) |
| [Model Router](https://github.com/FvdHMBAI/model-router) | LLM routing across 5 providers, 6 tiers |
| [Graphify Toolkit](https://github.com/FvdHMBAI/graphify-toolkit) | Codebase knowledge graphs |
| [Night Shift](https://github.com/FvdHMBAI/nightshift) | Overnight lint, types, security fixes |
| [Autonomie-OS](https://github.com/FvdHMBAI/autonomie-os) | Self-improving agent framework |
| [Claude Code Blueprint](https://github.com/FvdHMBAI/claude-code-blueprint) | Patterns from running 13+ SaaS products |

```bash
curl -fsSL https://raw.githubusercontent.com/FvdHMBAI/agent-stack/main/install.sh | bash
```

**Cost:** EUR 0. Forever.

---

## Pro . EUR 79/dev/month

**For teams shipping AI-powered products in regulated environments.**

Save ~30% compared to buying GuardRail Pro + Compliance Shield individually.

Everything in Free, plus:

| Capability | Detail |
|---|---|
| **GuardRail Pro guards** | Script content analysis, multi-step attack detection, supply chain audit |
| **PII Shield v2** | ML-powered personal data detection in agent output |
| **Compliance Shield managed** | Hosted in Germany, AVV/DPA included, 99.9% uptime |
| **EU AI Act compliance kit** | Guard-to-article mapping, PDF audit reports for regulators |
| **Penetration test framework** | 50+ attack patterns, automated regression |
| **Priority support** | 24h response time, direct channel |

### What Pro solves

Without Pro, you have strong guards for known attack patterns. Pro adds:

1. **Defense in depth** . Script content analysis catches attacks that bypass command-line guards (agent writes payload to file, then executes it)
2. **Regulatory evidence** . PDF reports that map your controls to EU AI Act articles. Hand them to your compliance team or auditor
3. **Managed PII scanning** . You don't need to run and maintain the Compliance Shield infrastructure. We host it, you call the API
4. **Continuous validation** . The penetration test framework runs 50+ attack patterns against your guard configuration. Know what's covered before an incident proves it

[Get AgentStack Pro](https://agentstack.promptandbuild.de)

---

## Enterprise . Custom pricing

**For organizations that need contractual guarantees.**

Everything in Pro, plus:

| Capability | Detail |
|---|---|
| **Custom country plugins** | Your country's identifiers, your validation rules |
| **On-premise deployment** | Run the full stack in your infrastructure |
| **SLA** | Contractual uptime and response-time guarantees |
| **Dedicated support** | Named contact, quarterly review calls |
| **Custom guard development** | Guards built for your specific compliance requirements |
| **Training** | Team onboarding for guard authoring, knowledge graphs, overnight automation |
| **SSO integration** | Connect to your identity provider |

[Contact us](mailto:enterprise@promptandbuild.de) for a tailored proposal.

---

## Comparison

| | Free | Pro | Enterprise |
|---|:---:|:---:|:---:|
| Pre-execution guards | 11 | 18+ | Custom |
| PII detection (deterministic) | 10 countries | 10 countries | Custom countries |
| PII detection (ML-powered) | . | Yes | Yes |
| Model routing | Yes | Yes | Yes |
| Knowledge graphs | Yes | Yes | Yes |
| Overnight automation | Yes | Yes | Yes |
| Self-improvement framework | Yes | Yes | Yes |
| Script content analysis | . | Yes | Yes |
| Multi-step attack detection | . | Yes | Yes |
| Supply chain audit | . | Yes | Yes |
| Penetration test framework | . | 50+ patterns | Custom patterns |
| EU AI Act compliance reports | . | Yes | Yes |
| Managed Compliance Shield | . | Hosted (DE) | On-premise option |
| AVV/DPA | . | Included | Included |
| Support | Community | Priority (24h) | Dedicated + SLA |
| **Price** | **EUR 0** | **EUR 79/dev/month** | **Custom** |

---

## FAQ

**Can I use the free tier in production?**
Yes. The MIT and AGPL-3.0 components are production-ready. They power 15 applications processing 600+ blocked commands per week.

**What happens if I stop paying for Pro?**
Your free-tier guards keep working. Pro-specific guards (script analysis, multi-step detection, supply chain) deactivate. Your audit logs and compliance reports remain yours.

**Do I need all components?**
No. Each component installs independently. The bundle is the fastest way to get everything, but you can pick what you need.

**Is there a trial?**
14-day free trial for Pro. No credit card required. [Start trial](https://agentstack.promptandbuild.de)

**How does billing work?**
Per developer seat, monthly. Annual billing available at 20% discount (EUR 63/dev/month).

---

<p align="center">
  <a href="https://agentstack.promptandbuild.de"><strong>Get AgentStack Pro</strong></a> · <a href="mailto:enterprise@promptandbuild.de">Enterprise inquiry</a>
</p>
