<script lang="ts">
  import { goto } from "$app/navigation";
  import { page } from "$app/state";
  import { Button } from "$lib/features/shared/components/_shadcn/ui/button";
  import { ArrowLeft } from "@lucide/svelte";

  let { children } = $props();

  let label = $derived.by(() => {
    let url = page.url.pathname;
    switch (url) {
      case "/timer-sequence":
        return "Timers Sequenciais";
      case "/colors":
        return "Treino de Cores";
    }
    return "";
  });
</script>

<div class="container mx-auto px-4 py-4">
  <div class="flex gap-2 items-center mb-6">
    <Button
      variant="ghost"
      size="icon"
      onclick={() => goto("/")}
      class="text-white hover:thai-bg-gradient"
    >
      <ArrowLeft class="w-6 h-6" />
    </Button>

    <p class="text-xl font-bold text-white">{label}</p>
  </div>

  {@render children()}
</div>
