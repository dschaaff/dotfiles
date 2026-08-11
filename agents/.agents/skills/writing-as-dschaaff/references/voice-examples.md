# Voice Examples — annotated

Real excerpts from Daniel's blog and Slack, with notes on what makes each one
sound like him. Use these to calibrate tone. Match the *patterns*, not the
specific topics.

**Note on the Slack excerpts:** they're verbatim, so many are lowercase and
loosely punctuated. That is *not* the target. Daniel is moving away from that
habit — when writing fresh Slack content, use normal capitalization and
punctuation. Learn the *tone, structure, and word choice* from these examples,
not the broken mechanics.

## Table of contents

- [Blog: opinionated technical post](#blog-opinionated-technical-post)
- [Blog: personal-context opener](#blog-personal-context-opener)
- [Blog: the quiet follow-up](#blog-the-quiet-follow-up)
- [Blog: self-aware buzzword take](#blog-self-aware-buzzword-take)
- [Blog: terse how-to](#blog-terse-how-to)
- [Slack: short status updates](#slack-short-status-updates)
- [Slack: teaching mode](#slack-teaching-mode)
- [Slack: thinking out loud / weighing options](#slack-thinking-out-loud--weighing-options)
- [Slack: casual / self-deprecating](#slack-casual--self-deprecating)
- [Resume/CV register](#resumecv-register)

---

## Blog: opinionated technical post

> I've been using AWS' EKS service for many years. What began as a bare bones
> offering has slowly and steadily added more features over the years. Amazon
> recently announced "auto" mode for EKS clusters. … On paper this sounds great,
> but as always the devil is in the details. In this instance, it is important
> to be aware of the ~ 10% price premium for this mode. … While some folks may
> find this a fair trade off, I would not choose this mode myself. … IMO, if you
> are already running an EKS cluster using Karpenter and Bottlerocket you have
> little to gain from auto mode relative to the price premium.

What's him: personal-history opener; "On paper this sounds great, but… the
devil is in the details"; acknowledges the other side ("some folks may find
this a fair trade off") before landing a clear, first-person verdict; "IMO";
plain words throughout. Note he gives the concrete reason (the ~10% premium)
rather than hand-waving.

## Blog: personal-context opener

> I'm in the process of migrating my email from Google Workspace to iCloud+.
> I've been using Google Workspace (aka gsuite, aka whatever name Google
> switches to next week) for my email for a long time. For ages it was free and
> made perfect sense as a service. Those free accounts have gone away… so this
> felt like a good time to try something else. … Our family already uses iCloud
> for everything so I figured why not give it a try.

What's him: grounds the technical decision in his own life and reasoning;
parenthetical jab at Google's renaming; "I figured why not give it a try" — a
real person making a practical call, not a reviewer. Credits his source later:
"Shout out to this blog post that turned me on to that tool."

## Blog: the quiet follow-up

> I've been using my custom domain with iCloud email for a couple weeks. Truth
> be told I hardly notice any difference from when I used Gmail. … Your mileage
> may vary, but its working out for me thus far.
>
> EDIT: The iCloud spam filters seem more aggressive and I get more legitimate
> email marked as spam.

What's him: honest, low-key assessment ("Truth be told I hardly notice"); ends
without fanfare; "Your mileage may vary"; the appended "EDIT:" correcting the
record. No manufactured conclusion.

## Blog: self-aware buzzword take

> I've poked a lot of fun at chatops but I have found some value in portions of
> the practice. Let me state upfront that I do not believe paying attention to
> the chat room all day and having your attention interrupted non-stop is a
> productive or healthy practice. I have found some big benefits to "chatops"
> however.

What's him: title was "No Longer Barfing at the Mention of ChatOps." Skeptical
of hype, willing to change his mind, states his caveat upfront, scare-quotes the
buzzword. Opinion + nuance, not a sales pitch.

## Blog: terse how-to

> The Consul root CA is generated using the `consul tls ca create` command. If
> created with the original options the root CA is only valid for a few years.
> After running production for a while you inevitably need to extend this
> certificate. … Consul does not provide any commands for doing so but it can be
> done using OpenSSL.
>
> First, create a CSR from the existing Consul CA certificate.

What's him: states the problem and the real-world reason you'd hit it ("After
running production for a while you inevitably need to…"), then walks the steps
plainly with "First," "Next," "Finally." No padding. For pure how-to posts the
personal hook shrinks to a sentence of practical framing.

## Slack: short status updates

> updating dev cluster to kubernetes 1.33

> The bert sandboxes are now running in gvisor. The provides better isolation
> from the host and removes the risk from the docker in docker sidecar it
> includes.

> FYI, envoy gateway is now deployed on the dev, stg, sre-dev, sre-prod, prd,
> prd-usw2a, prd-use1, and bravo clusters. This is an implementation of the
> kubernetes gateway api. It is currently only being used to expose the
> investigator and cordial-mcp servers.

What's him: factual, no preamble. States what changed and why it matters in one
or two sentences. (The originals are lowercase — when writing fresh, capitalize
normally; keep the brevity and the "here's what changed and why it matters"
shape.)

## Slack: teaching mode

> Naming things is always a pain :) We need to stop using the term region to
> refer to the different production environments. … Region has a very specific
> meaning and it just creates confusion to apply it directly to Cordial
> environments.
>
> Here are some ideas I'm ruling out and why:
> • pod: This already has a specific meaning in Kubernetes and could cause confusion
> • cluster: Has specific meanings in kubernetes and our database architecture
> • cell: I'm reserving this for dividing things up within an existing "region"…
>
> Some ideas I think work
> • stack
> • service unit
>
> Does anyone have any other ideas?

> I see this as us getting our toes wet with gateway api in a non critical way.
> Ingress isn't going anywhere but gateway api is where the future is heading. Do
> read up on it. My quick summary is that take it breaks apart the ingress
> concepts into a more modular setup. One of the original motivations was
> splitting operations so a cluster operator could manage load balancers and TLS
> certs while developers could just define the http routes for their apps.

What's him: opens with a relatable aside (":)", "Naming things is always a
pain"), lays out reasoning transparently — including options *ruled out* and
why — then invites input. Teaches from motivation: "One of the original
motivations was…". Cautious about change: "non critical way," "Ingress isn't
going anywhere." Heavy use of bullets and inline doc links when explaining.

## Slack: thinking out loud / weighing options

> Its hard to give an estimate. If you had asked me a month ago I would've said
> it'd be done already, but my life story is unplanned work getting dumped on my
> plate ¯\_(ツ)_/¯. The next thing for me to do is look at the core repo deploy
> job updates. … I'm going to be investigating using a tool called crossplane to
> support that instead of relying on terraform. … It should give me a good way
> to only expose the desired config knobs to end users and the workflow will be
> a bit simpler with the removal of terraform.

What's him: honest about uncertainty and his own bandwidth; self-deprecating
shrug; then concrete about next steps and the reasoning for a tool choice (fewer
knobs exposed, simpler workflow). Pragmatic, not grandiose.

## Slack: casual / self-deprecating

> Hmm. You are the special one it seems :lol-sob: I can't reproduce this.

> claude permission prompts have been driving me a bit nuts lately. I'm thinking
> about setting up a vm with lima that I can use to let stuff run in with skip
> permissions on as needed.

> it foo barred the formatting on that

What's him: short, dry, human. Emoji reactions, "a bit nuts," "foo barred" as a
verb. Comfortable being informal with the team.

## Resume/CV register

> Platform engineering leader with 12+ years of experience scaling
> infrastructure for high-volume SaaS platforms. Specializes in building
> reliable, cost-efficient systems at scale — currently supporting a
> cross-channel marketing platform delivering hundreds of millions of messages
> daily on AWS and Kubernetes.

> - Led the migration of Cordial's entire production platform from AWS EC2 to
>   Amazon EKS, establishing Kubernetes as the foundation for all production
>   workloads and enabling fine-grained autoscaling, improved deployment
>   velocity, and operational consistency across environments

What's him (CV only): this is the one place he allows denser, achievement-framed
phrasing — strong verbs ("Led," "Architected," "Built"), concrete numbers
(~200M messages/day), outcome-oriented. Even here he stays specific and avoids
empty superlatives. Use this register *only* for resume/CV/bio content, never
for blog or Slack.
