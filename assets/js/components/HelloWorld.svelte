<script lang="ts">
  export let week_nr, request;

  let show_modal = false;

  function clicko() {
    show_modal = !show_modal;
  }
  function submit() {
    request("weeks", {}, console.log);
  }
</script>

<div>
  <button on:click={clicko} class="bg-slate-700 text-white shadow rounded p-3">
    Create new timesheet
  </button>
  {#if show_modal}
    <form on:click|preventDefault={submit}>
      <button type="submit">submitti</button>
    </form>
  {/if}
</div>
